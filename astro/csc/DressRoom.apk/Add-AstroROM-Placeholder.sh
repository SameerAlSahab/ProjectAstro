# Scamsung , i will not let you remove ai wallpapers
find . -type f -exec sed -i 's/CscFeature_Common_SupportZProjectFunctionInGlobal/CscFeature_Common_SupportAstroROMInGlobal/g' {} +

sed -i 's/android:extractNativeLibs="false"/android:extractNativeLibs="true"/g' AndroidManifest.xml
