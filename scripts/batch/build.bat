@echo off

cd "project"
haxelib run hxcpp Build.xml
DEL  "obj"
cd "%CD%.\ndll"
DEL  "Windows64\*%CD%hash"
DEL  "Windows\*%CD%hash"
REM UNKNOWN: {"type":"Redirect","op":{"text":">","type":"great"},"file":{"text":"/dev/null","type":"Word"}}