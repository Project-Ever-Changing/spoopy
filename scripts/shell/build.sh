cd project

haxelib run hxcpp Build.xml

rm -Rf "obj"

cd ../ndll

{
    rm Windows64/*.hash
    rm Windows/*.hash
    rm Mac64/*.hash
    rm Mac/*.hash
    rm Linux64/*.hash
    rm Linux/*.hash
}&> /dev/null