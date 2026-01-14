#!/usr/bin/env python3
"""
Smalipatcher: A utility tool to apply patches to smali files.
Reads a .smalipatch file and applies changes to smali code.
"""

import os
import sys
import re
import argparse
from typing import List, Tuple, Optional

class Colors:
    """ANSI color codes"""
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'

    @staticmethod
    def init():

        if os.name == 'nt':
            try:
                import colorama
                colorama.init()
            except ImportError:
                pass

def log(msg: str, color: str = '', quiet: bool = False):

    if not quiet:
        print(f"{color}{msg}{Colors.RESET if color else ''}")

def log_error(msg: str):

    print(f"{Colors.RED}{msg}{Colors.RESET}")

def parse_smalipatch(lines: List[str]) -> List[dict]:

    patches = []
    i = 0

    while i < len(lines):
        line = lines[i].strip()


        if not line or line.startswith('#') or line.startswith('//'):
            i += 1
            continue


        if line.startswith('AUTHOR '):
            author = line[7:].strip()
            log(f"  Author: {author}", Colors.BLUE)
            i += 1
            continue


        if line.startswith('FILE '):
            file_path = line[5:].strip()
            patch = {'type': 'FILE', 'file_path': file_path, 'actions': []}
            i += 1


            while i < len(lines):
                line = lines[i].strip()

                if not line or line.startswith('#') or line.startswith('//'):
                    i += 1
                    continue

                if line == 'END' or line.startswith('FILE '):
                    if line == 'END':
                        i += 1
                    break

                if line.startswith('REPLACE '):
                    method_sig = line[8:].strip()
                    content, i = read_content_block(lines, i + 1)
                    patch['actions'].append({
                        'type': 'REPLACE',
                        'method_sig': method_sig,
                        'content': content
                    })
                elif line.startswith('FIND_REPLACE '):
                    # FIND_REPLACE "old" "new"
                    parts = parse_quoted_args(line[13:])
                    if len(parts) == 2:
                        patch['actions'].append({
                            'type': 'FIND_REPLACE',
                            'old': parts[0],
                            'new': parts[1]
                        })
                    i += 1
                elif line.startswith('PATCH'):
                    # PATCH or PATCH .method signature
                    rest = line[5:].strip()
                    method_sig = rest if rest else None
                    content, i = read_content_block(lines, i + 1)
                    patch['actions'].append({
                        'type': 'PATCH',
                        'method_sig': method_sig,
                        'content': content
                    })
                else:
                    i += 1

            if patch['actions']:
                patches.append(patch)
        else:
            i += 1

    return patches

def parse_quoted_args(text: str) -> List[str]:

    args = []
    in_quote = False
    current = []
    i = 0

    while i < len(text):
        c = text[i]
        if c == '"':
            if in_quote:
                args.append(''.join(current))
                current = []
                in_quote = False
            else:
                in_quote = True
        elif in_quote:
            if c == '\\' and i + 1 < len(text):
                current.append(text[i + 1])
                i += 1
            else:
                current.append(c)
        i += 1

    return args

def read_content_block(lines: List[str], start: int) -> Tuple[List[str], int]:

    content = []
    i = start
    keywords = ['END', 'REPLACE ', 'PATCH', 'FIND_REPLACE ', 'FILE ']

    while i < len(lines):
        line = lines[i]
        line_strip = line.strip()

        # Check if line starts with a keyword
        if any(line_strip.startswith(kw) for kw in keywords):
            break

        content.append(line.rstrip())
        i += 1

    return content, i

def find_method_range(lines: List[str], method_sig: str) -> Tuple[int, int]:

    pattern = re.compile(r'^\s*' + re.escape(method_sig))

    for i, line in enumerate(lines):
        if pattern.match(line):
            # Find .end method
            for j in range(i + 1, len(lines)):
                if lines[j].strip() == '.end method':
                    return i, j
            # No .end method found, return line before .end class or EOF
            for j in range(len(lines) - 1, i, -1):
                if lines[j].strip().startswith('.end class'):
                    return i, j - 1
            return i, len(lines) - 1

    return -1, -1

def apply_replace(lines: List[str], action: dict, quiet: bool) -> Optional[List[str]]:

    method_sig = action['method_sig']
    start_idx, end_idx = find_method_range(lines, method_sig)

    if start_idx == -1:
        log_error(f"  ✗ Method not found: {method_sig}")
        return None


    new_lines = lines[:start_idx]
    new_lines.append(lines[start_idx])
    new_lines.extend(action['content'])


    has_end_method = any(line.strip() == '.end method' for line in action['content'])
    if not has_end_method:
        new_lines.append('.end method')

    new_lines.extend(lines[end_idx + 1:])

    log(f"    ✓ Replaced method at line {start_idx + 1}", Colors.GREEN, quiet)
    return new_lines

def apply_find_replace(lines: List[str], action: dict, quiet: bool) -> Optional[List[str]]:

    old_val = action['old']
    new_val = action['new']
    count = 0

    new_lines = []
    for line in lines:
        if old_val in line:
            new_lines.append(line.replace(old_val, new_val))
            count += 1
        else:
            new_lines.append(line)

    if count == 0:
        log_error(f"  ✗ Pattern not found: {old_val}")
        return None

    log(f"    ✓ Replaced {count} occurrence(s)", Colors.GREEN, quiet)
    return new_lines

def normalize_line(line: str) -> str:

    return line.strip()

def apply_patch(lines: List[str], action: dict, quiet: bool) -> Optional[List[str]]:

    content = action['content']
    method_sig = action.get('method_sig')

    # Separate context and changes
    context_lines = []
    changes = []

    for line in content:
        if line.startswith('+ '):
            changes.append(('+', line[2:]))
        elif line.startswith('- '):
            changes.append(('-', line[2:]))
        else:
            context_lines.append(normalize_line(line))


    search_start = 0
    search_end = len(lines)

    if method_sig:
        start_idx, end_idx = find_method_range(lines, method_sig)
        if start_idx == -1:
            log_error(f"  ✗ Method not found: {method_sig}")
            return None
        search_start = start_idx
        search_end = end_idx + 1

    # Find context in file
    if context_lines:
        match_idx = -1
        for i in range(search_start, search_end):
            # Try to match all context lines
            matched = True
            line_idx = i

            for ctx in context_lines:
                # Skip to next non-empty line
                while line_idx < search_end and not normalize_line(lines[line_idx]):
                    line_idx += 1

                if line_idx >= search_end:
                    matched = False
                    break

                if normalize_line(lines[line_idx]) != ctx:
                    matched = False
                    break

                line_idx += 1

            if matched:
                match_idx = i
                break

        if match_idx == -1:
            log_error(f"  ✗ Context not found")
            if context_lines:
                log_error(f"     Looking for: {context_lines[0][:50]}...")
            return None


        new_lines = lines[:match_idx]

        for op, line in changes:
            if op == '+':
                new_lines.append(line)
            elif op == '-':
                pass


        skip_count = len([c for c in changes if c[0] == '-'])
        new_lines.extend(lines[match_idx + skip_count:])

        log(f"     Applied patch at line {match_idx + 1}", Colors.GREEN, quiet)
        return new_lines
    else:

        new_lines = lines[:]
        for op, line in changes:
            if op == '+':
                new_lines.append(line)

        log(f"     Applied patch", Colors.GREEN, quiet)
        return new_lines

def apply_patch_to_file(work_dir: str, patch: dict, quiet: bool) -> bool:
    """Apply a patch to a file"""
    file_path = patch['file_path']
    full_path = os.path.join(work_dir, file_path)

    if not os.path.exists(full_path):
        log_error(f"   File not found: {file_path}")
        return False

    log(f"  Patching: {file_path}", Colors.YELLOW, quiet)

    # Read file
    try:
        with open(full_path, 'r', encoding='utf-8') as f:
            lines = [line.rstrip('\n\r') for line in f.readlines()]
    except Exception as e:
        log_error(f"   Failed to read file: {e}")
        return False

    # Apply each action
    modified = False
    for i, action in enumerate(patch['actions']):
        action_type = action['type']

        if action_type == 'REPLACE':
            result = apply_replace(lines, action, quiet)
        elif action_type == 'FIND_REPLACE':
            result = apply_find_replace(lines, action, quiet)
        elif action_type == 'PATCH':
            result = apply_patch(lines, action, quiet)
        else:
            log_error(f"   Unknown action type: {action_type}")
            return False

        if result is None:
            log_error(f"   Hunk failed at action {i + 1}")
            return False

        lines = result
        modified = True

    # Write file
    if modified:
        try:
            with open(full_path, 'w', encoding='utf-8', newline='\n') as f:
                f.write('\n'.join(lines) + '\n')
            log(f" File patched successfully", Colors.GREEN, quiet)
        except Exception as e:
            log_error(f" Failed to write file {e}")
            return False

    return True

def main():
    parser = argparse.ArgumentParser(
        description='Smalipatcher: Apply patches to smali files',
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument('work_dir', help='Root directory containing smali files')
    parser.add_argument('patch_file', help='Path to .smalipatch file')
    parser.add_argument('-q', '--quiet', action='store_true',
                       help='Quiet mode (only show errors)')

    args = parser.parse_args()

    Colors.init()

    # Validate inputs
    if not os.path.isdir(args.work_dir):
        log_error(f"ERROR: Directory not found {args.work_dir}")
        sys.exit(1)

    if not os.path.isfile(args.patch_file):
        log_error(f"ERROR: Patch file not found {args.patch_file}")
        sys.exit(1)


    try:
        with open(args.patch_file, 'r', encoding='utf-8') as f:
            lines = [line.rstrip('\n\r') for line in f.readlines()]
    except Exception as e:
        log_error(f"ERROR: Failed to read patch file: {e}")
        sys.exit(1)

    # Parse patches
    patches = parse_smalipatch(lines)

    if not patches:
        log_error("ERROR: No valid patches found")
        sys.exit(1)

    log(f"Found {len(patches)} file(s) to patch", Colors.BLUE, args.quiet)
    log("=" * 50, '', args.quiet)

    # Apply patches
    success_count = 0
    for patch in patches:
        if apply_patch_to_file(args.work_dir, patch, args.quiet):
            success_count += 1
        log("", '', args.quiet)


    log("=" * 50, '', args.quiet)
    if success_count == len(patches):
        log(f" Success: {success_count}/{len(patches)} files patched", Colors.GREEN, args.quiet)
        sys.exit(0)
    else:
        log_error(f" Failed: {success_count}/{len(patches)} files patched")
        sys.exit(1)

if __name__ == '__main__':
    main()
