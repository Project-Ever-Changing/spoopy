@echo off

cd "project"
haxelib run hxcpp Build.xml
DEL  "obj"
cd "%CD%.\ndll"
DEL  "Windows64\*%CD%hash"
DEL  "Windows\*%CD%hash"