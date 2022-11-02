@echo off

git submodule init
git submodule update

cd "project"
haxelib run hxcpp Build.xml
DEL  "obj"
cd "%CD%.\ndll"
DEL  "Windows64\*%CD%hash"
DEL  "Windows\*%CD%hash"