import sys

import math as python_lib_Math
import math as Math
from os import path as python_lib_os_Path
import inspect as python_lib_Inspect
import re as python_lib_Re
import sys as python_lib_Sys
import builtins as python_lib_Builtins
import functools as python_lib_Functools
import json as python_lib_Json
import os as python_lib_Os
import random as python_lib_Random
import select as python_lib_Select
import shutil as python_lib_Shutil
import subprocess as python_lib_Subprocess
import traceback as python_lib_Traceback
from datetime import datetime as python_lib_datetime_Datetime
from datetime import timezone as python_lib_datetime_Timezone
from io import BufferedReader as python_lib_io_BufferedReader
from io import BufferedWriter as python_lib_io_BufferedWriter
from io import StringIO as python_lib_io_StringIO
from io import TextIOWrapper as python_lib_io_TextIOWrapper
from socket import socket as python_lib_socket_Socket
from subprocess import Popen as python_lib_subprocess_Popen
import urllib.parse as python_lib_urllib_Parse


class _hx_AnonObject:
    _hx_disable_getattr = False
    def __init__(self, fields):
        self.__dict__ = fields
    def __repr__(self):
        return repr(self.__dict__)
    def __contains__(self, item):
        return item in self.__dict__
    def __getitem__(self, item):
        return self.__dict__[item]
    def __getattr__(self, name):
        if (self._hx_disable_getattr):
            raise AttributeError('field does not exist')
        else:
            return None
    def _hx_hasattr(self,field):
        self._hx_disable_getattr = True
        try:
            getattr(self, field)
            self._hx_disable_getattr = False
            return True
        except AttributeError:
            self._hx_disable_getattr = False
            return False



class Enum:
    _hx_class_name = "Enum"
    __slots__ = ("tag", "index", "params")
    _hx_fields = ["tag", "index", "params"]
    _hx_methods = ["__str__"]

    def __init__(self,tag,index,params):
        self.tag = tag
        self.index = index
        self.params = params

    def __str__(self):
        if (self.params is None):
            return self.tag
        else:
            return self.tag + '(' + (', '.join(str(v) for v in self.params)) + ')'

Enum._hx_class = Enum


class Class: pass


class Date:
    _hx_class_name = "Date"
    __slots__ = ("date", "dateUTC")
    _hx_fields = ["date", "dateUTC"]
    _hx_methods = ["toString"]
    _hx_statics = ["now", "fromTime", "makeLocal"]

    def __init__(self,year,month,day,hour,_hx_min,sec):
        self.dateUTC = None
        if (year < python_lib_datetime_Datetime.min.year):
            year = python_lib_datetime_Datetime.min.year
        if (day == 0):
            day = 1
        self.date = Date.makeLocal(python_lib_datetime_Datetime(year,(month + 1),day,hour,_hx_min,sec,0))
        self.dateUTC = self.date.astimezone(python_lib_datetime_Timezone.utc)

    def toString(self):
        return self.date.strftime("%Y-%m-%d %H:%M:%S")

    @staticmethod
    def now():
        d = Date(2000,0,1,0,0,0)
        d.date = Date.makeLocal(python_lib_datetime_Datetime.now())
        d.dateUTC = d.date.astimezone(python_lib_datetime_Timezone.utc)
        return d

    @staticmethod
    def fromTime(t):
        d = Date(2000,0,1,0,0,0)
        d.date = Date.makeLocal(python_lib_datetime_Datetime.fromtimestamp((t / 1000.0)))
        d.dateUTC = d.date.astimezone(python_lib_datetime_Timezone.utc)
        return d

    @staticmethod
    def makeLocal(date):
        try:
            return date.astimezone()
        except BaseException as _g:
            None
            tzinfo = python_lib_datetime_Datetime.now(python_lib_datetime_Timezone.utc).astimezone().tzinfo
            return date.replace(**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'tzinfo': tzinfo})))

Date._hx_class = Date


class EReg:
    _hx_class_name = "EReg"
    __slots__ = ("pattern", "matchObj", "_hx_global")
    _hx_fields = ["pattern", "matchObj", "global"]
    _hx_methods = ["split", "replace"]

    def __init__(self,r,opt):
        self.matchObj = None
        self._hx_global = False
        options = 0
        _g = 0
        _g1 = len(opt)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = (-1 if ((i >= len(opt))) else ord(opt[i]))
            if (c == 109):
                options = (options | python_lib_Re.M)
            if (c == 105):
                options = (options | python_lib_Re.I)
            if (c == 115):
                options = (options | python_lib_Re.S)
            if (c == 117):
                options = (options | python_lib_Re.U)
            if (c == 103):
                self._hx_global = True
        self.pattern = python_lib_Re.compile(r,options)

    def split(self,s):
        if self._hx_global:
            ret = []
            lastEnd = 0
            x = python_HaxeIterator(python_lib_Re.finditer(self.pattern,s))
            while x.hasNext():
                x1 = x.next()
                x2 = HxString.substring(s,lastEnd,x1.start())
                ret.append(x2)
                lastEnd = x1.end()
            x = HxString.substr(s,lastEnd,None)
            ret.append(x)
            return ret
        else:
            self.matchObj = python_lib_Re.search(self.pattern,s)
            if (self.matchObj is None):
                return [s]
            else:
                return [HxString.substring(s,0,self.matchObj.start()), HxString.substr(s,self.matchObj.end(),None)]

    def replace(self,s,by):
        _this = by.split("$$")
        by = "_hx_#repl#__".join([python_Boot.toString1(x1,'') for x1 in _this])
        def _hx_local_0(x):
            res = by
            g = x.groups()
            _g = 0
            _g1 = len(g)
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                gs = g[i]
                if (gs is None):
                    continue
                delimiter = ("$" + HxOverrides.stringOrNull(str((i + 1))))
                _this = (list(res) if ((delimiter == "")) else res.split(delimiter))
                res = gs.join([python_Boot.toString1(x1,'') for x1 in _this])
            _this = res.split("_hx_#repl#__")
            res = "$".join([python_Boot.toString1(x1,'') for x1 in _this])
            return res
        replace = _hx_local_0
        return python_lib_Re.sub(self.pattern,replace,s,(0 if (self._hx_global) else 1))

EReg._hx_class = EReg


class Reflect:
    _hx_class_name = "Reflect"
    __slots__ = ()
    _hx_statics = ["field", "setField", "getProperty", "callMethod", "isFunction", "isObject"]

    @staticmethod
    def field(o,field):
        return python_Boot.field(o,field)

    @staticmethod
    def setField(o,field,value):
        setattr(o,(("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field)),value)

    @staticmethod
    def getProperty(o,field):
        if (o is None):
            return None
        if (field in python_Boot.keywords):
            field = ("_hx_" + field)
        elif ((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95))):
            field = ("_hx_" + field)
        if isinstance(o,_hx_AnonObject):
            return Reflect.field(o,field)
        tmp = Reflect.field(o,("get_" + ("null" if field is None else field)))
        if ((tmp is not None) and callable(tmp)):
            return tmp()
        else:
            return Reflect.field(o,field)

    @staticmethod
    def callMethod(o,func,args):
        if callable(func):
            return func(*args)
        else:
            return None

    @staticmethod
    def isFunction(f):
        if (not ((python_lib_Inspect.isfunction(f) or python_lib_Inspect.ismethod(f)))):
            return python_Boot.hasField(f,"func_code")
        else:
            return True

    @staticmethod
    def isObject(v):
        _g = Type.typeof(v)
        tmp = _g.index
        if (tmp == 4):
            return True
        elif (tmp == 6):
            _g1 = _g.params[0]
            return True
        else:
            return False
Reflect._hx_class = Reflect


class RunScript:
    _hx_class_name = "RunScript"
    __slots__ = ()
    _hx_statics = ["haxeLibPath", "projectCMDS", "runFromHaxelib", "debug", "commandList", "main", "commands", "setupCMD", "nekoCompatible", "importCMD", "buildCMD", "lsCMD", "destroyCMD", "updateCMD", "buildScript", "getXMLArgs", "readLine", "runScript", "askYN"]

    @staticmethod
    def main():
        args = Sys.args()
        cwd = (None if ((len(args) == 0)) else args.pop())
        RunScript.commands(args)
        Sys.setCwd(cwd)
        Sys.exit(1)

    @staticmethod
    def commands(args):
        if ((len(args) == 0) or (((args[0] if 0 < len(args) else None) == "help"))):
            displayInfo = utils_DisplayInfo(RunScript.commandList)
            return
        _g = (args[0] if 0 < len(args) else None)
        _hx_local_0 = len(_g)
        if (_hx_local_0 == 10):
            if (_g == "build_ndll"):
                have_API = ""
                build_args = []
                if (not sys_FileSystem.exists((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll"))):
                    sys_FileSystem.createDirectory((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll"))
                if ((python_internal_ArrayImpl.indexOf(args,"-no_vulkan",None) <= 0) and (not massive_sys_io_FileSys.get_isMac())):
                    have_API = "-DSPOOPY_VULKAN"
                    build_args.append(have_API)
                if ((python_internal_ArrayImpl.indexOf(args,"-no_metal",None) <= 0) and massive_sys_io_FileSys.get_isMac()):
                    have_API = "-DSPOOPY_METAL"
                    build_args.append(have_API)
                x = ("-DSPOOPY_INCLUDE_EXAMPLE" if ((python_internal_ArrayImpl.indexOf(args,"-include_example",None) > 0)) else "-DSPOOPY_EMPTY")
                build_args.append(x)
                cleanG_API = []
                if sys_FileSystem.exists("project/obj"):
                    sys_FileSystem.deleteDirectory("project/obj")
                _g = 0
                _g1 = len(build_args)
                while (_g < _g1):
                    i = _g
                    _g = (_g + 1)
                    _this = (build_args[i] if i >= 0 and i < len(build_args) else None)
                    x = python_internal_ArrayImpl._get(_this.split("_"), 1).lower()
                    cleanG_API.append(x)
                _g = 0
                while (_g < len(cleanG_API)):
                    api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
                    _g = (_g + 1)
                    if (not sys_FileSystem.exists(("ndll-" + ("null" if api is None else api)))):
                        python_internal_ArrayImpl.remove(cleanG_API,api)
                _g = 0
                while (_g < len(cleanG_API)):
                    api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
                    _g = (_g + 1)
                    find = ""
                    while True:
                        find = utils_PathUtils.recursivelyFindFile(("ndll-" + ("null" if api is None else api)),"lime.ndll.hash")
                        if (find != ""):
                            sys_FileSystem.deleteFile(find)
                        if (not ((find != ""))):
                            break
                Sys.setCwd("project")
                Sys.command("haxelib",(["run", "hxcpp", "Build.xml.tpl"] + build_args))
            else:
                hxp_Log.error((("Invalid command: '" + HxOverrides.stringOrNull((args[0] if 0 < len(args) else None))) + "'"))
        elif (_hx_local_0 == 11):
            if (_g == "import_ndll"):
                arg1 = (len(args) >= 2)
                arg2 = (len(args) >= 3)
                libName = ""
                gitUrl = ""
                if arg1:
                    libName = (args[1] if 1 < len(args) else None)
                else:
                    Sys.stdout().writeString("Module Name: ")
                    libName = Sys.stdin().readLine()
                if arg2:
                    gitUrl = (args[2] if 2 < len(args) else None)
                else:
                    Sys.stdout().writeString("Git Path: ")
                    gitUrl = Sys.stdin().readLine()
                downloadPath = ((HxOverrides.stringOrNull(Sys.getCwd()) + "/") + ("null" if libName is None else libName))
                host = sys_net_Host("github.com")
                gitSocket = sys_net_Socket()
                gitSocket.connect(host,443)
                gitSocket.waitForRead()
                hxp_Log.info(gitSocket.read())
            else:
                hxp_Log.error((("Invalid command: '" + HxOverrides.stringOrNull((args[0] if 0 < len(args) else None))) + "'"))
        elif (_hx_local_0 == 12):
            if (_g == "destroy_ndll"):
                fileLocation = "scripts/"
                scripts = []
                if sys_FileSystem.exists((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll")):
                    if massive_sys_io_FileSys.get_isWindows():
                        scripts = ["batch/destroy.bat"]
                        _g = 0
                        _g1 = len(scripts)
                        while (_g < _g1):
                            i = _g
                            _g = (_g + 1)
                            if sys_FileSystem.exists(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))):
                                Sys.command(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
                            else:
                                hxp_Log.error(((("Could not find script: " + HxOverrides.stringOrNull(Sys.getCwd())) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
                    else:
                        scripts = ["shell/destroy.sh"]
                        _g = 0
                        _g1 = len(scripts)
                        while (_g < _g1):
                            i = _g
                            _g = (_g + 1)
                            if sys_FileSystem.exists(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))):
                                Sys.command("bash",[((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))])
                            else:
                                hxp_Log.error(((("Could not find script: " + HxOverrides.stringOrNull(Sys.getCwd())) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
            else:
                hxp_Log.error((("Invalid command: '" + HxOverrides.stringOrNull((args[0] if 0 < len(args) else None))) + "'"))
        elif (_hx_local_0 == 5):
            if (_g == "setup"):
                if (len(args) != 0):
                    limeDirectory = hxp_Haxelib.getPath(hxp_Haxelib("lime"))
                    tmp = None
                    if (not (((limeDirectory is None) or ((limeDirectory == ""))))):
                        startIndex = None
                        tmp = (((limeDirectory.find("is not installed") if ((startIndex is None)) else HxString.indexOfImpl(limeDirectory,"is not installed",startIndex))) > -1)
                    else:
                        tmp = True
                    if tmp:
                        Sys.command("haxelib",["install", "lime"])
                    answer = RunScript.askYN("Do you want to setup the command alias?")
                    if answer:
                        if massive_sys_io_FileSys.get_isWindows():
                            haxePath = Sys.getEnv("HAXEPATH")
                            if ((haxePath is None) or ((haxePath == ""))):
                                haxePath = "C:\\HaxeToolkit\\haxe\\"
                            batchFile = "spoopy.bat"
                            scriptSourcePath = Sys.getCwd()
                            scriptSourcePath = utils_PathUtils.combine(scriptSourcePath,"bin")
                            scriptSourcePath = utils_PathUtils.combine(scriptSourcePath,batchFile)
                            if sys_FileSystem.exists(scriptSourcePath):
                                sys_io_File.copy(scriptSourcePath,((("null" if haxePath is None else haxePath) + "\\") + ("null" if batchFile is None else batchFile)))
                            else:
                                hxp_Log.error("Could not find the spoopy alias script. You can try 'haxelib selfupdate' and run setup again.")
                        else:
                            binPath = ("/usr/local/bin" if (massive_sys_io_FileSys.get_isMac()) else "/usr/bin")
                            shellScript = Sys.getCwd()
                            shellScript = utils_PathUtils.combine(shellScript,"bin")
                            shellScript = utils_PathUtils.combine(shellScript,"spoopy.sh")
                            if sys_FileSystem.exists(shellScript):
                                Sys.command("sudo",["cp", shellScript, (("null" if binPath is None else binPath) + "/spoopy")])
                                Sys.command("sudo",["chmod", "+x", (("null" if binPath is None else binPath) + "/spoopy")])
                            else:
                                hxp_Log.error("Could not find the spoopy alias script. You can try 'spoopy selfupdate' and run setup again.")
            else:
                hxp_Log.error((("Invalid command: '" + HxOverrides.stringOrNull((args[0] if 0 < len(args) else None))) + "'"))
        elif (_hx_local_0 == 4):
            if (_g == "test"):
                if (not sys_FileSystem.exists("tools.n")):
                    Sys.command("haxe",["tools.hxml"])
                Sys.command("neko",(["tools.n"] + args))
            else:
                hxp_Log.error((("Invalid command: '" + HxOverrides.stringOrNull((args[0] if 0 < len(args) else None))) + "'"))
        elif (_hx_local_0 == 6):
            if (_g == "create"):
                if (not sys_FileSystem.exists("tools.n")):
                    Sys.command("haxe",["tools.hxml"])
                Sys.command("neko",(["tools.n"] + args))
            elif (_g == "update"):
                Sys.command("haxelib",["update", "spoopy"])
                if (python_internal_ArrayImpl.indexOf(args,"-git",None) > 0):
                    Sys.command("git",["submodule", "update", "--init", "--recursive", "--remote"])
                if (python_internal_ArrayImpl.indexOf(args,"-ndll",None) > 0):
                    fileLocation = "scripts/"
                    scripts = []
                    if sys_FileSystem.exists((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll")):
                        if massive_sys_io_FileSys.get_isWindows():
                            scripts = ["batch/destroy.bat"]
                            _g = 0
                            _g1 = len(scripts)
                            while (_g < _g1):
                                i = _g
                                _g = (_g + 1)
                                if sys_FileSystem.exists(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))):
                                    Sys.command(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
                                else:
                                    hxp_Log.error(((("Could not find script: " + HxOverrides.stringOrNull(Sys.getCwd())) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
                        else:
                            scripts = ["shell/destroy.sh"]
                            _g = 0
                            _g1 = len(scripts)
                            while (_g < _g1):
                                i = _g
                                _g = (_g + 1)
                                if sys_FileSystem.exists(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))):
                                    Sys.command("bash",[((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))])
                                else:
                                    hxp_Log.error(((("Could not find script: " + HxOverrides.stringOrNull(Sys.getCwd())) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
                    have_API = ""
                    build_args = []
                    if (not sys_FileSystem.exists((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll"))):
                        sys_FileSystem.createDirectory((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll"))
                    if ((python_internal_ArrayImpl.indexOf(args,"-no_vulkan",None) <= 0) and (not massive_sys_io_FileSys.get_isMac())):
                        have_API = "-DSPOOPY_VULKAN"
                        build_args.append(have_API)
                    if ((python_internal_ArrayImpl.indexOf(args,"-no_metal",None) <= 0) and massive_sys_io_FileSys.get_isMac()):
                        have_API = "-DSPOOPY_METAL"
                        build_args.append(have_API)
                    x = ("-DSPOOPY_INCLUDE_EXAMPLE" if ((python_internal_ArrayImpl.indexOf(args,"-include_example",None) > 0)) else "-DSPOOPY_EMPTY")
                    build_args.append(x)
                    cleanG_API = []
                    if sys_FileSystem.exists("project/obj"):
                        sys_FileSystem.deleteDirectory("project/obj")
                    _g = 0
                    _g1 = len(build_args)
                    while (_g < _g1):
                        i = _g
                        _g = (_g + 1)
                        _this = (build_args[i] if i >= 0 and i < len(build_args) else None)
                        x = python_internal_ArrayImpl._get(_this.split("_"), 1).lower()
                        cleanG_API.append(x)
                    _g = 0
                    while (_g < len(cleanG_API)):
                        api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
                        _g = (_g + 1)
                        if (not sys_FileSystem.exists(("ndll-" + ("null" if api is None else api)))):
                            python_internal_ArrayImpl.remove(cleanG_API,api)
                    _g = 0
                    while (_g < len(cleanG_API)):
                        api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
                        _g = (_g + 1)
                        find = ""
                        while True:
                            find = utils_PathUtils.recursivelyFindFile(("ndll-" + ("null" if api is None else api)),"lime.ndll.hash")
                            if (find != ""):
                                sys_FileSystem.deleteFile(find)
                            if (not ((find != ""))):
                                break
                    Sys.setCwd("project")
                    Sys.command("haxelib",(["run", "hxcpp", "Build.xml.tpl"] + build_args))
            else:
                hxp_Log.error((("Invalid command: '" + HxOverrides.stringOrNull((args[0] if 0 < len(args) else None))) + "'"))
        elif (_hx_local_0 == 2):
            if (_g == "ls"):
                if (len(args) > 1):
                    Sys.command("ls",[(HxOverrides.stringOrNull(Sys.getCwd()) + HxOverrides.stringOrNull((args[1] if 1 < len(args) else None)))])
                else:
                    Sys.command("ls")
            else:
                hxp_Log.error((("Invalid command: '" + HxOverrides.stringOrNull((args[0] if 0 < len(args) else None))) + "'"))
        else:
            hxp_Log.error((("Invalid command: '" + HxOverrides.stringOrNull((args[0] if 0 < len(args) else None))) + "'"))

    @staticmethod
    def setupCMD(args):
        if (len(args) == 0):
            return
        limeDirectory = hxp_Haxelib.getPath(hxp_Haxelib("lime"))
        tmp = None
        if (not (((limeDirectory is None) or ((limeDirectory == ""))))):
            startIndex = None
            tmp = (((limeDirectory.find("is not installed") if ((startIndex is None)) else HxString.indexOfImpl(limeDirectory,"is not installed",startIndex))) > -1)
        else:
            tmp = True
        if tmp:
            Sys.command("haxelib",["install", "lime"])
        answer = RunScript.askYN("Do you want to setup the command alias?")
        if (not answer):
            return
        if massive_sys_io_FileSys.get_isWindows():
            haxePath = Sys.getEnv("HAXEPATH")
            if ((haxePath is None) or ((haxePath == ""))):
                haxePath = "C:\\HaxeToolkit\\haxe\\"
            batchFile = "spoopy.bat"
            scriptSourcePath = Sys.getCwd()
            scriptSourcePath = utils_PathUtils.combine(scriptSourcePath,"bin")
            scriptSourcePath = utils_PathUtils.combine(scriptSourcePath,batchFile)
            if sys_FileSystem.exists(scriptSourcePath):
                sys_io_File.copy(scriptSourcePath,((("null" if haxePath is None else haxePath) + "\\") + ("null" if batchFile is None else batchFile)))
            else:
                hxp_Log.error("Could not find the spoopy alias script. You can try 'haxelib selfupdate' and run setup again.")
        else:
            binPath = ("/usr/local/bin" if (massive_sys_io_FileSys.get_isMac()) else "/usr/bin")
            shellScript = Sys.getCwd()
            shellScript = utils_PathUtils.combine(shellScript,"bin")
            shellScript = utils_PathUtils.combine(shellScript,"spoopy.sh")
            if sys_FileSystem.exists(shellScript):
                Sys.command("sudo",["cp", shellScript, (("null" if binPath is None else binPath) + "/spoopy")])
                Sys.command("sudo",["chmod", "+x", (("null" if binPath is None else binPath) + "/spoopy")])
            else:
                hxp_Log.error("Could not find the spoopy alias script. You can try 'spoopy selfupdate' and run setup again.")

    @staticmethod
    def nekoCompatible(args):
        if (not sys_FileSystem.exists("tools.n")):
            Sys.command("haxe",["tools.hxml"])
        Sys.command("neko",(["tools.n"] + args))

    @staticmethod
    def importCMD(args):
        arg1 = (len(args) >= 2)
        arg2 = (len(args) >= 3)
        libName = ""
        gitUrl = ""
        if arg1:
            libName = (args[1] if 1 < len(args) else None)
        else:
            Sys.stdout().writeString("Module Name: ")
            libName = Sys.stdin().readLine()
        if arg2:
            gitUrl = (args[2] if 2 < len(args) else None)
        else:
            Sys.stdout().writeString("Git Path: ")
            gitUrl = Sys.stdin().readLine()
        downloadPath = ((HxOverrides.stringOrNull(Sys.getCwd()) + "/") + ("null" if libName is None else libName))
        host = sys_net_Host("github.com")
        gitSocket = sys_net_Socket()
        gitSocket.connect(host,443)
        gitSocket.waitForRead()
        hxp_Log.info(gitSocket.read())

    @staticmethod
    def buildCMD(args):
        fileLocation = "scripts/"
        have_API = ""
        build_args = []
        if (not sys_FileSystem.exists((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll"))):
            sys_FileSystem.createDirectory((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll"))
        if ((python_internal_ArrayImpl.indexOf(args,"-no_vulkan",None) <= 0) and (not massive_sys_io_FileSys.get_isMac())):
            have_API = "-DSPOOPY_VULKAN"
            build_args.append(have_API)
        if ((python_internal_ArrayImpl.indexOf(args,"-no_metal",None) <= 0) and massive_sys_io_FileSys.get_isMac()):
            have_API = "-DSPOOPY_METAL"
            build_args.append(have_API)
        x = ("-DSPOOPY_INCLUDE_EXAMPLE" if ((python_internal_ArrayImpl.indexOf(args,"-include_example",None) > 0)) else "-DSPOOPY_EMPTY")
        build_args.append(x)
        cleanG_API = []
        if sys_FileSystem.exists("project/obj"):
            sys_FileSystem.deleteDirectory("project/obj")
        _g = 0
        _g1 = len(build_args)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            _this = (build_args[i] if i >= 0 and i < len(build_args) else None)
            x = python_internal_ArrayImpl._get(_this.split("_"), 1).lower()
            cleanG_API.append(x)
        _g = 0
        while (_g < len(cleanG_API)):
            api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
            _g = (_g + 1)
            if (not sys_FileSystem.exists(("ndll-" + ("null" if api is None else api)))):
                python_internal_ArrayImpl.remove(cleanG_API,api)
        _g = 0
        while (_g < len(cleanG_API)):
            api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
            _g = (_g + 1)
            find = ""
            while True:
                find = utils_PathUtils.recursivelyFindFile(("ndll-" + ("null" if api is None else api)),"lime.ndll.hash")
                if (find != ""):
                    sys_FileSystem.deleteFile(find)
                if (not ((find != ""))):
                    break
        Sys.setCwd("project")
        Sys.command("haxelib",(["run", "hxcpp", "Build.xml.tpl"] + build_args))

    @staticmethod
    def lsCMD(args):
        if (len(args) > 1):
            Sys.command("ls",[(HxOverrides.stringOrNull(Sys.getCwd()) + HxOverrides.stringOrNull((args[1] if 1 < len(args) else None)))])
        else:
            Sys.command("ls")

    @staticmethod
    def destroyCMD(args):
        fileLocation = "scripts/"
        scripts = []
        if (not sys_FileSystem.exists((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll"))):
            return
        if massive_sys_io_FileSys.get_isWindows():
            scripts = ["batch/destroy.bat"]
            _g = 0
            _g1 = len(scripts)
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                if sys_FileSystem.exists(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))):
                    Sys.command(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
                else:
                    hxp_Log.error(((("Could not find script: " + HxOverrides.stringOrNull(Sys.getCwd())) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
        else:
            scripts = ["shell/destroy.sh"]
            _g = 0
            _g1 = len(scripts)
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                if sys_FileSystem.exists(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))):
                    Sys.command("bash",[((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))])
                else:
                    hxp_Log.error(((("Could not find script: " + HxOverrides.stringOrNull(Sys.getCwd())) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))

    @staticmethod
    def updateCMD(args):
        Sys.command("haxelib",["update", "spoopy"])
        if (python_internal_ArrayImpl.indexOf(args,"-git",None) > 0):
            Sys.command("git",["submodule", "update", "--init", "--recursive", "--remote"])
        if (python_internal_ArrayImpl.indexOf(args,"-ndll",None) > 0):
            fileLocation = "scripts/"
            scripts = []
            if sys_FileSystem.exists((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll")):
                if massive_sys_io_FileSys.get_isWindows():
                    scripts = ["batch/destroy.bat"]
                    _g = 0
                    _g1 = len(scripts)
                    while (_g < _g1):
                        i = _g
                        _g = (_g + 1)
                        if sys_FileSystem.exists(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))):
                            Sys.command(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
                        else:
                            hxp_Log.error(((("Could not find script: " + HxOverrides.stringOrNull(Sys.getCwd())) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
                else:
                    scripts = ["shell/destroy.sh"]
                    _g = 0
                    _g1 = len(scripts)
                    while (_g < _g1):
                        i = _g
                        _g = (_g + 1)
                        if sys_FileSystem.exists(((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))):
                            Sys.command("bash",[((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None)))])
                        else:
                            hxp_Log.error(((("Could not find script: " + HxOverrides.stringOrNull(Sys.getCwd())) + ("null" if fileLocation is None else fileLocation)) + HxOverrides.stringOrNull((scripts[i] if i >= 0 and i < len(scripts) else None))))
            have_API = ""
            build_args = []
            if (not sys_FileSystem.exists((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll"))):
                sys_FileSystem.createDirectory((HxOverrides.stringOrNull(Sys.getCwd()) + "ndll"))
            if ((python_internal_ArrayImpl.indexOf(args,"-no_vulkan",None) <= 0) and (not massive_sys_io_FileSys.get_isMac())):
                have_API = "-DSPOOPY_VULKAN"
                build_args.append(have_API)
            if ((python_internal_ArrayImpl.indexOf(args,"-no_metal",None) <= 0) and massive_sys_io_FileSys.get_isMac()):
                have_API = "-DSPOOPY_METAL"
                build_args.append(have_API)
            x = ("-DSPOOPY_INCLUDE_EXAMPLE" if ((python_internal_ArrayImpl.indexOf(args,"-include_example",None) > 0)) else "-DSPOOPY_EMPTY")
            build_args.append(x)
            cleanG_API = []
            if sys_FileSystem.exists("project/obj"):
                sys_FileSystem.deleteDirectory("project/obj")
            _g = 0
            _g1 = len(build_args)
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                _this = (build_args[i] if i >= 0 and i < len(build_args) else None)
                x = python_internal_ArrayImpl._get(_this.split("_"), 1).lower()
                cleanG_API.append(x)
            _g = 0
            while (_g < len(cleanG_API)):
                api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
                _g = (_g + 1)
                if (not sys_FileSystem.exists(("ndll-" + ("null" if api is None else api)))):
                    python_internal_ArrayImpl.remove(cleanG_API,api)
            _g = 0
            while (_g < len(cleanG_API)):
                api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
                _g = (_g + 1)
                find = ""
                while True:
                    find = utils_PathUtils.recursivelyFindFile(("ndll-" + ("null" if api is None else api)),"lime.ndll.hash")
                    if (find != ""):
                        sys_FileSystem.deleteFile(find)
                    if (not ((find != ""))):
                        break
            Sys.setCwd("project")
            Sys.command("haxelib",(["run", "hxcpp", "Build.xml.tpl"] + build_args))

    @staticmethod
    def buildScript(have_API):
        cleanG_API = []
        if sys_FileSystem.exists("project/obj"):
            sys_FileSystem.deleteDirectory("project/obj")
        _g = 0
        _g1 = len(have_API)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            _this = (have_API[i] if i >= 0 and i < len(have_API) else None)
            x = python_internal_ArrayImpl._get(_this.split("_"), 1).lower()
            cleanG_API.append(x)
        _g = 0
        while (_g < len(cleanG_API)):
            api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
            _g = (_g + 1)
            if (not sys_FileSystem.exists(("ndll-" + ("null" if api is None else api)))):
                python_internal_ArrayImpl.remove(cleanG_API,api)
        _g = 0
        while (_g < len(cleanG_API)):
            api = (cleanG_API[_g] if _g >= 0 and _g < len(cleanG_API) else None)
            _g = (_g + 1)
            find = ""
            while True:
                find = utils_PathUtils.recursivelyFindFile(("ndll-" + ("null" if api is None else api)),"lime.ndll.hash")
                if (find != ""):
                    sys_FileSystem.deleteFile(find)
                if (not ((find != ""))):
                    break
        Sys.setCwd("project")
        Sys.command("haxelib",(["run", "hxcpp", "Build.xml.tpl"] + have_API))

    @staticmethod
    def getXMLArgs(args,lookingFor):
        if (python_internal_ArrayImpl.indexOf(args,lookingFor,None) > 0):
            if (lookingFor == "-include_example"):
                return "-DSPOOPY_INCLUDE_EXAMPLE"
            else:
                return "-DSPOOPY_EMPTY"
        return "-DSPOOPY_EMPTY"

    @staticmethod
    def readLine():
        return Sys.stdin().readLine()

    @staticmethod
    def runScript(path,file):
        if massive_sys_io_FileSys.get_isWindows():
            script = (((("null" if path is None else path) + "/batch/") + ("null" if file is None else file)) + ".bat")
            Sys.command((HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if script is None else script)))
        else:
            script = (((("null" if path is None else path) + "/shell/") + ("null" if file is None else file)) + ".sh")
            Sys.command("bash",[(HxOverrides.stringOrNull(Sys.getCwd()) + ("null" if script is None else script))])

    @staticmethod
    def askYN(question):
        while True:
            _hx_str = ""
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            str1 = Std.string((("null" if question is None else question) + " [y/n]?"))
            python_Lib.printString((("" + ("null" if str1 is None else str1)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            _g = Sys.stdin().readLine()
            _hx_local_0 = len(_g)
            if (_hx_local_0 == 1):
                if (_g == "y"):
                    return True
                elif (_g == "n"):
                    return False
                else:
                    return False
            elif (_hx_local_0 == 3):
                if (_g == "Yes"):
                    return True
                elif (_g == "yes"):
                    return True
                else:
                    return False
            elif (_hx_local_0 == 2):
                if (_g == "No"):
                    return False
                elif (_g == "no"):
                    return False
                else:
                    return False
            else:
                return False
RunScript._hx_class = RunScript


class Std:
    _hx_class_name = "Std"
    __slots__ = ()
    _hx_statics = ["isOfType", "string", "parseInt", "shortenPossibleNumber", "parseFloat"]

    @staticmethod
    def isOfType(v,t):
        if ((v is None) and ((t is None))):
            return False
        if (t is None):
            return False
        if ((type(t) == type) and (t == Dynamic)):
            return (v is not None)
        isBool = isinstance(v,bool)
        if (((type(t) == type) and (t == Bool)) and isBool):
            return True
        if ((((not isBool) and (not ((type(t) == type) and (t == Bool)))) and ((type(t) == type) and (t == Int))) and isinstance(v,int)):
            return True
        vIsFloat = isinstance(v,float)
        tmp = None
        tmp1 = None
        if (((not isBool) and vIsFloat) and ((type(t) == type) and (t == Int))):
            f = v
            tmp1 = (((f != Math.POSITIVE_INFINITY) and ((f != Math.NEGATIVE_INFINITY))) and (not python_lib_Math.isnan(f)))
        else:
            tmp1 = False
        if tmp1:
            tmp1 = None
            try:
                tmp1 = int(v)
            except BaseException as _g:
                None
                tmp1 = None
            tmp = (v == tmp1)
        else:
            tmp = False
        if ((tmp and ((v <= 2147483647))) and ((v >= -2147483648))):
            return True
        if (((not isBool) and ((type(t) == type) and (t == Float))) and isinstance(v,(float, int))):
            return True
        if ((type(t) == type) and (t == str)):
            return isinstance(v,str)
        isEnumType = ((type(t) == type) and (t == Enum))
        if ((isEnumType and python_lib_Inspect.isclass(v)) and hasattr(v,"_hx_constructs")):
            return True
        if isEnumType:
            return False
        isClassType = ((type(t) == type) and (t == Class))
        if ((((isClassType and (not isinstance(v,Enum))) and python_lib_Inspect.isclass(v)) and hasattr(v,"_hx_class_name")) and (not hasattr(v,"_hx_constructs"))):
            return True
        if isClassType:
            return False
        tmp = None
        try:
            tmp = isinstance(v,t)
        except BaseException as _g:
            None
            tmp = False
        if tmp:
            return True
        if python_lib_Inspect.isclass(t):
            cls = t
            loop = None
            def _hx_local_1(intf):
                f = (intf._hx_interfaces if (hasattr(intf,"_hx_interfaces")) else [])
                if (f is not None):
                    _g = 0
                    while (_g < len(f)):
                        i = (f[_g] if _g >= 0 and _g < len(f) else None)
                        _g = (_g + 1)
                        if (i == cls):
                            return True
                        else:
                            l = loop(i)
                            if l:
                                return True
                    return False
                else:
                    return False
            loop = _hx_local_1
            currentClass = v.__class__
            result = False
            while (currentClass is not None):
                if loop(currentClass):
                    result = True
                    break
                currentClass = python_Boot.getSuperClass(currentClass)
            return result
        else:
            return False

    @staticmethod
    def string(s):
        return python_Boot.toString1(s,"")

    @staticmethod
    def parseInt(x):
        if (x is None):
            return None
        try:
            return int(x)
        except BaseException as _g:
            None
            base = 10
            _hx_len = len(x)
            foundCount = 0
            sign = 0
            firstDigitIndex = 0
            lastDigitIndex = -1
            previous = 0
            _g = 0
            _g1 = _hx_len
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                c = (-1 if ((i >= len(x))) else ord(x[i]))
                if (((c > 8) and ((c < 14))) or ((c == 32))):
                    if (foundCount > 0):
                        return None
                    continue
                else:
                    c1 = c
                    if (c1 == 43):
                        if (foundCount == 0):
                            sign = 1
                        elif (not (((48 <= c) and ((c <= 57))))):
                            if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                break
                    elif (c1 == 45):
                        if (foundCount == 0):
                            sign = -1
                        elif (not (((48 <= c) and ((c <= 57))))):
                            if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                break
                    elif (c1 == 48):
                        if (not (((foundCount == 0) or (((foundCount == 1) and ((sign != 0))))))):
                            if (not (((48 <= c) and ((c <= 57))))):
                                if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                    break
                    elif ((c1 == 120) or ((c1 == 88))):
                        if ((previous == 48) and ((((foundCount == 1) and ((sign == 0))) or (((foundCount == 2) and ((sign != 0))))))):
                            base = 16
                        elif (not (((48 <= c) and ((c <= 57))))):
                            if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                break
                    elif (not (((48 <= c) and ((c <= 57))))):
                        if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                            break
                if (((foundCount == 0) and ((sign == 0))) or (((foundCount == 1) and ((sign != 0))))):
                    firstDigitIndex = i
                foundCount = (foundCount + 1)
                lastDigitIndex = i
                previous = c
            if (firstDigitIndex <= lastDigitIndex):
                digits = HxString.substring(x,firstDigitIndex,(lastDigitIndex + 1))
                try:
                    return (((-1 if ((sign == -1)) else 1)) * int(digits,base))
                except BaseException as _g:
                    return None
            return None

    @staticmethod
    def shortenPossibleNumber(x):
        r = ""
        _g = 0
        _g1 = len(x)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = ("" if (((i < 0) or ((i >= len(x))))) else x[i])
            _g2 = HxString.charCodeAt(c,0)
            if (_g2 is None):
                break
            else:
                _g3 = _g2
                if (((((((((((_g3 == 57) or ((_g3 == 56))) or ((_g3 == 55))) or ((_g3 == 54))) or ((_g3 == 53))) or ((_g3 == 52))) or ((_g3 == 51))) or ((_g3 == 50))) or ((_g3 == 49))) or ((_g3 == 48))) or ((_g3 == 46))):
                    r = (("null" if r is None else r) + ("null" if c is None else c))
                else:
                    break
        return r

    @staticmethod
    def parseFloat(x):
        try:
            return float(x)
        except BaseException as _g:
            None
            if (x is not None):
                r1 = Std.shortenPossibleNumber(x)
                if (r1 != x):
                    return Std.parseFloat(r1)
            return Math.NaN
Std._hx_class = Std


class Float: pass


class Int: pass


class Bool: pass


class Dynamic: pass


class StringBuf:
    _hx_class_name = "StringBuf"
    __slots__ = ("b",)
    _hx_fields = ["b"]
    _hx_methods = ["get_length"]

    def __init__(self):
        self.b = python_lib_io_StringIO()

    def get_length(self):
        pos = self.b.tell()
        self.b.seek(0,2)
        _hx_len = self.b.tell()
        self.b.seek(pos,0)
        return _hx_len

StringBuf._hx_class = StringBuf


class StringTools:
    _hx_class_name = "StringTools"
    __slots__ = ()
    _hx_statics = ["htmlEscape", "htmlUnescape", "isSpace", "ltrim", "rtrim", "trim", "lpad", "rpad", "replace", "hex"]

    @staticmethod
    def htmlEscape(s,quotes = None):
        buf_b = python_lib_io_StringIO()
        _g_offset = 0
        _g_s = s
        while (_g_offset < len(_g_s)):
            index = _g_offset
            _g_offset = (_g_offset + 1)
            code = ord(_g_s[index])
            code1 = code
            if (code1 == 34):
                if quotes:
                    buf_b.write("&quot;")
                else:
                    buf_b.write("".join(map(chr,[code])))
            elif (code1 == 38):
                buf_b.write("&amp;")
            elif (code1 == 39):
                if quotes:
                    buf_b.write("&#039;")
                else:
                    buf_b.write("".join(map(chr,[code])))
            elif (code1 == 60):
                buf_b.write("&lt;")
            elif (code1 == 62):
                buf_b.write("&gt;")
            else:
                buf_b.write("".join(map(chr,[code])))
        return buf_b.getvalue()

    @staticmethod
    def htmlUnescape(s):
        _this = s.split("&gt;")
        _this1 = ">".join([python_Boot.toString1(x1,'') for x1 in _this])
        _this = _this1.split("&lt;")
        _this1 = "<".join([python_Boot.toString1(x1,'') for x1 in _this])
        _this = _this1.split("&quot;")
        _this1 = "\"".join([python_Boot.toString1(x1,'') for x1 in _this])
        _this = _this1.split("&#039;")
        _this1 = "'".join([python_Boot.toString1(x1,'') for x1 in _this])
        _this = _this1.split("&amp;")
        return "&".join([python_Boot.toString1(x1,'') for x1 in _this])

    @staticmethod
    def isSpace(s,pos):
        if (((len(s) == 0) or ((pos < 0))) or ((pos >= len(s)))):
            return False
        c = HxString.charCodeAt(s,pos)
        if (not (((c > 8) and ((c < 14))))):
            return (c == 32)
        else:
            return True

    @staticmethod
    def ltrim(s):
        l = len(s)
        r = 0
        while ((r < l) and StringTools.isSpace(s,r)):
            r = (r + 1)
        if (r > 0):
            return HxString.substr(s,r,(l - r))
        else:
            return s

    @staticmethod
    def rtrim(s):
        l = len(s)
        r = 0
        while ((r < l) and StringTools.isSpace(s,((l - r) - 1))):
            r = (r + 1)
        if (r > 0):
            return HxString.substr(s,0,(l - r))
        else:
            return s

    @staticmethod
    def trim(s):
        return StringTools.ltrim(StringTools.rtrim(s))

    @staticmethod
    def lpad(s,c,l):
        if (len(c) <= 0):
            return s
        buf = StringBuf()
        l = (l - len(s))
        while (buf.get_length() < l):
            s1 = Std.string(c)
            buf.b.write(s1)
        s1 = Std.string(s)
        buf.b.write(s1)
        return buf.b.getvalue()

    @staticmethod
    def rpad(s,c,l):
        if (len(c) <= 0):
            return s
        buf = StringBuf()
        s1 = Std.string(s)
        buf.b.write(s1)
        while (buf.get_length() < l):
            s = Std.string(c)
            buf.b.write(s)
        return buf.b.getvalue()

    @staticmethod
    def replace(s,sub,by):
        _this = (list(s) if ((sub == "")) else s.split(sub))
        return by.join([python_Boot.toString1(x1,'') for x1 in _this])

    @staticmethod
    def hex(n,digits = None):
        s = ""
        hexChars = "0123456789ABCDEF"
        while True:
            index = (n & 15)
            s = (HxOverrides.stringOrNull((("" if (((index < 0) or ((index >= len(hexChars))))) else hexChars[index]))) + ("null" if s is None else s))
            n = HxOverrides.rshift(n, 4)
            if (not ((n > 0))):
                break
        if ((digits is not None) and ((len(s) < digits))):
            diff = (digits - len(s))
            _g = 0
            _g1 = diff
            while (_g < _g1):
                _ = _g
                _g = (_g + 1)
                s = ("0" + ("null" if s is None else s))
        return s
StringTools._hx_class = StringTools


class sys_FileSystem:
    _hx_class_name = "sys.FileSystem"
    __slots__ = ()
    _hx_statics = ["exists", "stat", "fullPath", "isDirectory", "createDirectory", "deleteFile", "deleteDirectory", "readDirectory"]

    @staticmethod
    def exists(path):
        return python_lib_os_Path.exists(path)

    @staticmethod
    def stat(path):
        s = python_lib_Os.stat(path)
        return _hx_AnonObject({'gid': s.st_gid, 'uid': s.st_uid, 'atime': Date.fromTime((1000 * s.st_atime)), 'mtime': Date.fromTime((1000 * s.st_mtime)), 'ctime': Date.fromTime((1000 * s.st_ctime)), 'size': s.st_size, 'dev': s.st_dev, 'ino': s.st_ino, 'nlink': s.st_nlink, 'rdev': getattr(s,"st_rdev",0), 'mode': s.st_mode})

    @staticmethod
    def fullPath(relPath):
        return python_lib_os_Path.realpath(relPath)

    @staticmethod
    def isDirectory(path):
        return python_lib_os_Path.isdir(path)

    @staticmethod
    def createDirectory(path):
        python_lib_Os.makedirs(path,511,True)

    @staticmethod
    def deleteFile(path):
        python_lib_Os.remove(path)

    @staticmethod
    def deleteDirectory(path):
        python_lib_Os.rmdir(path)

    @staticmethod
    def readDirectory(path):
        return python_lib_Os.listdir(path)
sys_FileSystem._hx_class = sys_FileSystem


class Sys:
    _hx_class_name = "Sys"
    __slots__ = ()
    _hx_statics = ["environ", "get_environ", "exit", "args", "getEnv", "getCwd", "setCwd", "systemName", "command", "stdin", "stdout", "stderr"]
    environ = None

    @staticmethod
    def get_environ():
        _g = Sys.environ
        if (_g is None):
            environ = haxe_ds_StringMap()
            env = python_lib_Os.environ
            key = python_HaxeIterator(iter(env.keys()))
            while key.hasNext():
                key1 = key.next()
                value = env.get(key1,None)
                environ.h[key1] = value
            def _hx_local_1():
                def _hx_local_0():
                    Sys.environ = environ
                    return Sys.environ
                return _hx_local_0()
            return _hx_local_1()
        else:
            env = _g
            return env

    @staticmethod
    def exit(code):
        python_lib_Sys.exit(code)

    @staticmethod
    def args():
        argv = python_lib_Sys.argv
        return argv[1:None]

    @staticmethod
    def getEnv(s):
        return Sys.get_environ().h.get(s,None)

    @staticmethod
    def getCwd():
        return python_lib_Os.getcwd()

    @staticmethod
    def setCwd(s):
        python_lib_Os.chdir(s)

    @staticmethod
    def systemName():
        _g = python_lib_Sys.platform
        x = _g
        if x.startswith("linux"):
            return "Linux"
        else:
            _g1 = _g
            _hx_local_0 = len(_g1)
            if (_hx_local_0 == 5):
                if (_g1 == "win32"):
                    return "Windows"
                else:
                    raise haxe_Exception.thrown("not supported platform")
            elif (_hx_local_0 == 6):
                if (_g1 == "cygwin"):
                    return "Windows"
                elif (_g1 == "darwin"):
                    return "Mac"
                else:
                    raise haxe_Exception.thrown("not supported platform")
            else:
                raise haxe_Exception.thrown("not supported platform")

    @staticmethod
    def command(cmd,args = None):
        if (args is None):
            return python_lib_Subprocess.call(cmd,**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'shell': True})))
        else:
            return python_lib_Subprocess.call(([cmd] + args))

    @staticmethod
    def stdin():
        return python_io_IoTools.createFileInputFromText(python_lib_Sys.stdin)

    @staticmethod
    def stdout():
        return python_io_IoTools.createFileOutputFromText(python_lib_Sys.stdout)

    @staticmethod
    def stderr():
        return python_io_IoTools.createFileOutputFromText(python_lib_Sys.stderr)
Sys._hx_class = Sys

class ValueType(Enum):
    __slots__ = ()
    _hx_class_name = "ValueType"
    _hx_constructs = ["TNull", "TInt", "TFloat", "TBool", "TObject", "TFunction", "TClass", "TEnum", "TUnknown"]

    @staticmethod
    def TClass(c):
        return ValueType("TClass", 6, (c,))

    @staticmethod
    def TEnum(e):
        return ValueType("TEnum", 7, (e,))
ValueType.TNull = ValueType("TNull", 0, ())
ValueType.TInt = ValueType("TInt", 1, ())
ValueType.TFloat = ValueType("TFloat", 2, ())
ValueType.TBool = ValueType("TBool", 3, ())
ValueType.TObject = ValueType("TObject", 4, ())
ValueType.TFunction = ValueType("TFunction", 5, ())
ValueType.TUnknown = ValueType("TUnknown", 8, ())
ValueType._hx_class = ValueType


class Type:
    _hx_class_name = "Type"
    __slots__ = ()
    _hx_statics = ["getClass", "getEnum", "getEnumName", "typeof"]

    @staticmethod
    def getClass(o):
        if (o is None):
            return None
        o1 = o
        if ((o1 is not None) and ((HxOverrides.eq(o1,str) or python_lib_Inspect.isclass(o1)))):
            return None
        if isinstance(o,_hx_AnonObject):
            return None
        if hasattr(o,"_hx_class"):
            return o._hx_class
        if hasattr(o,"__class__"):
            return o.__class__
        else:
            return None

    @staticmethod
    def getEnum(o):
        if (o is None):
            return None
        return o.__class__

    @staticmethod
    def getEnumName(e):
        return e._hx_class_name

    @staticmethod
    def typeof(v):
        if (v is None):
            return ValueType.TNull
        elif isinstance(v,bool):
            return ValueType.TBool
        elif isinstance(v,int):
            return ValueType.TInt
        elif isinstance(v,float):
            return ValueType.TFloat
        elif isinstance(v,str):
            return ValueType.TClass(str)
        elif isinstance(v,list):
            return ValueType.TClass(list)
        elif (isinstance(v,_hx_AnonObject) or python_lib_Inspect.isclass(v)):
            return ValueType.TObject
        elif isinstance(v,Enum):
            return ValueType.TEnum(v.__class__)
        elif (isinstance(v,type) or hasattr(v,"_hx_class")):
            return ValueType.TClass(v.__class__)
        elif callable(v):
            return ValueType.TFunction
        else:
            return ValueType.TUnknown
Type._hx_class = Type


class haxe_IMap:
    _hx_class_name = "haxe.IMap"
    __slots__ = ()
haxe_IMap._hx_class = haxe_IMap


class haxe_Exception(Exception):
    _hx_class_name = "haxe.Exception"
    __slots__ = ("_hx___nativeStack", "_hx___skipStack", "_hx___nativeException", "_hx___previousException")
    _hx_fields = ["__nativeStack", "__skipStack", "__nativeException", "__previousException"]
    _hx_methods = ["unwrap", "toString", "get_message", "get_native"]
    _hx_statics = ["caught", "thrown"]
    _hx_interfaces = []
    _hx_super = Exception


    def __init__(self,message,previous = None,native = None):
        self._hx___previousException = None
        self._hx___nativeException = None
        self._hx___nativeStack = None
        self._hx___skipStack = 0
        super().__init__(message)
        self._hx___previousException = previous
        if ((native is not None) and Std.isOfType(native,BaseException)):
            self._hx___nativeException = native
            self._hx___nativeStack = haxe_NativeStackTrace.exceptionStack()
        else:
            self._hx___nativeException = self
            infos = python_lib_Traceback.extract_stack()
            if (len(infos) != 0):
                infos.pop()
            infos.reverse()
            self._hx___nativeStack = infos

    def unwrap(self):
        return self._hx___nativeException

    def toString(self):
        return self.get_message()

    def get_message(self):
        return str(self)

    def get_native(self):
        return self._hx___nativeException

    @staticmethod
    def caught(value):
        if Std.isOfType(value,haxe_Exception):
            return value
        elif Std.isOfType(value,BaseException):
            return haxe_Exception(str(value),None,value)
        else:
            return haxe_ValueException(value,None,value)

    @staticmethod
    def thrown(value):
        if Std.isOfType(value,haxe_Exception):
            return value.get_native()
        elif Std.isOfType(value,BaseException):
            return value
        else:
            e = haxe_ValueException(value)
            e._hx___skipStack = (e._hx___skipStack + 1)
            return e

haxe_Exception._hx_class = haxe_Exception


class haxe_NativeStackTrace:
    _hx_class_name = "haxe.NativeStackTrace"
    __slots__ = ()
    _hx_statics = ["saveStack", "exceptionStack"]

    @staticmethod
    def saveStack(exception):
        pass

    @staticmethod
    def exceptionStack():
        exc = python_lib_Sys.exc_info()
        if (exc[2] is not None):
            infos = python_lib_Traceback.extract_tb(exc[2])
            infos.reverse()
            return infos
        else:
            return []
haxe_NativeStackTrace._hx_class = haxe_NativeStackTrace

class haxe__Template_TemplateExpr(Enum):
    __slots__ = ()
    _hx_class_name = "haxe._Template.TemplateExpr"
    _hx_constructs = ["OpVar", "OpExpr", "OpIf", "OpStr", "OpBlock", "OpForeach", "OpMacro"]

    @staticmethod
    def OpVar(v):
        return haxe__Template_TemplateExpr("OpVar", 0, (v,))

    @staticmethod
    def OpExpr(expr):
        return haxe__Template_TemplateExpr("OpExpr", 1, (expr,))

    @staticmethod
    def OpIf(expr,eif,eelse):
        return haxe__Template_TemplateExpr("OpIf", 2, (expr,eif,eelse))

    @staticmethod
    def OpStr(str):
        return haxe__Template_TemplateExpr("OpStr", 3, (str,))

    @staticmethod
    def OpBlock(l):
        return haxe__Template_TemplateExpr("OpBlock", 4, (l,))

    @staticmethod
    def OpForeach(expr,loop):
        return haxe__Template_TemplateExpr("OpForeach", 5, (expr,loop))

    @staticmethod
    def OpMacro(name,params):
        return haxe__Template_TemplateExpr("OpMacro", 6, (name,params))
haxe__Template_TemplateExpr._hx_class = haxe__Template_TemplateExpr


class haxe_iterators_ArrayIterator:
    _hx_class_name = "haxe.iterators.ArrayIterator"
    __slots__ = ("array", "current")
    _hx_fields = ["array", "current"]
    _hx_methods = ["hasNext", "next"]

    def __init__(self,array):
        self.current = 0
        self.array = array

    def hasNext(self):
        return (self.current < len(self.array))

    def next(self):
        def _hx_local_3():
            def _hx_local_2():
                _hx_local_0 = self
                _hx_local_1 = _hx_local_0.current
                _hx_local_0.current = (_hx_local_1 + 1)
                return _hx_local_1
            return python_internal_ArrayImpl._get(self.array, _hx_local_2())
        return _hx_local_3()

haxe_iterators_ArrayIterator._hx_class = haxe_iterators_ArrayIterator


class haxe_Template:
    _hx_class_name = "haxe.Template"
    __slots__ = ("expr", "context", "macros", "stack", "buf")
    _hx_fields = ["expr", "context", "macros", "stack", "buf"]
    _hx_methods = ["execute", "resolve", "parseTokens", "parseBlock", "parse", "parseExpr", "makeConst", "makePath", "makeExpr", "skipSpaces", "makeExpr2", "run"]
    _hx_statics = ["splitter", "expr_splitter", "expr_trim", "expr_int", "expr_float", "globals", "hxKeepArrayIterator"]

    def __init__(self,_hx_str):
        self.buf = None
        self.stack = None
        self.macros = None
        self.context = None
        self.expr = None
        tokens = self.parseTokens(_hx_str)
        self.expr = self.parseBlock(tokens)
        if (not tokens.isEmpty()):
            raise haxe_Exception.thrown((("Unexpected '" + Std.string(tokens.first().s)) + "'"))

    def execute(self,context,macros = None):
        self.macros = (_hx_AnonObject({}) if ((macros is None)) else macros)
        self.context = context
        self.stack = haxe_ds_List()
        self.buf = StringBuf()
        self.run(self.expr)
        return self.buf.b.getvalue()

    def resolve(self,v):
        if (v == "__current__"):
            return self.context
        if Reflect.isObject(self.context):
            value = Reflect.getProperty(self.context,v)
            if ((value is not None) or python_Boot.hasField(self.context,v)):
                return value
        _g_head = self.stack.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            ctx = val
            value = Reflect.getProperty(ctx,v)
            if ((value is not None) or python_Boot.hasField(ctx,v)):
                return value
        return Reflect.field(haxe_Template.globals,v)

    def parseTokens(self,data):
        tokens = haxe_ds_List()
        while True:
            _this = haxe_Template.splitter
            _this.matchObj = python_lib_Re.search(_this.pattern,data)
            if (not ((_this.matchObj is not None))):
                break
            _this1 = haxe_Template.splitter
            p_pos = _this1.matchObj.start()
            p_len = (_this1.matchObj.end() - _this1.matchObj.start())
            if (p_pos > 0):
                tokens.add(_hx_AnonObject({'p': HxString.substr(data,0,p_pos), 's': True, 'l': None}))
            if (HxString.charCodeAt(data,p_pos) == 58):
                tokens.add(_hx_AnonObject({'p': HxString.substr(data,(p_pos + 2),(p_len - 4)), 's': False, 'l': None}))
                _this2 = haxe_Template.splitter
                data = HxString.substr(_this2.matchObj.string,_this2.matchObj.end(),None)
                continue
            parp = (p_pos + p_len)
            npar = 1
            params = []
            part = ""
            while True:
                c = HxString.charCodeAt(data,parp)
                parp = (parp + 1)
                if (c == 40):
                    npar = (npar + 1)
                elif (c == 41):
                    npar = (npar - 1)
                    if (npar <= 0):
                        break
                elif (c is None):
                    raise haxe_Exception.thrown("Unclosed macro parenthesis")
                if ((c == 44) and ((npar == 1))):
                    params.append(part)
                    part = ""
                else:
                    part = (("null" if part is None else part) + HxOverrides.stringOrNull("".join(map(chr,[c]))))
            params.append(part)
            tokens.add(_hx_AnonObject({'p': haxe_Template.splitter.matchObj.group(2), 's': False, 'l': params}))
            data = HxString.substr(data,parp,(len(data) - parp))
        if (len(data) > 0):
            tokens.add(_hx_AnonObject({'p': data, 's': True, 'l': None}))
        return tokens

    def parseBlock(self,tokens):
        l = haxe_ds_List()
        while True:
            t = tokens.first()
            if (t is None):
                break
            if ((not t.s) and ((((t.p == "end") or ((t.p == "else"))) or ((HxString.substr(t.p,0,7) == "elseif "))))):
                break
            l.add(self.parse(tokens))
        if (l.length == 1):
            return l.first()
        return haxe__Template_TemplateExpr.OpBlock(l)

    def parse(self,tokens):
        t = tokens.pop()
        p = t.p
        if t.s:
            return haxe__Template_TemplateExpr.OpStr(p)
        if (t.l is not None):
            pe = haxe_ds_List()
            _g = 0
            _g1 = t.l
            while (_g < len(_g1)):
                p1 = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
                _g = (_g + 1)
                pe.add(self.parseBlock(self.parseTokens(p1)))
            return haxe__Template_TemplateExpr.OpMacro(p,pe)
        def _hx_local_2(kwd):
            pos = -1
            length = len(kwd)
            if (HxString.substr(p,0,length) == kwd):
                pos = length
                _g_offset = 0
                _g_s = HxString.substr(p,length,None)
                while (_g_offset < len(_g_s)):
                    index = _g_offset
                    _g_offset = (_g_offset + 1)
                    c = ord(_g_s[index])
                    if (c == 32):
                        pos = (pos + 1)
                    else:
                        break
            return pos
        kwdEnd = _hx_local_2
        pos = kwdEnd("if")
        if (pos > 0):
            p = HxString.substr(p,pos,(len(p) - pos))
            e = self.parseExpr(p)
            eif = self.parseBlock(tokens)
            t = tokens.first()
            eelse = None
            if (t is None):
                raise haxe_Exception.thrown("Unclosed 'if'")
            if (t.p == "end"):
                tokens.pop()
                eelse = None
            elif (t.p == "else"):
                tokens.pop()
                eelse = self.parseBlock(tokens)
                t = tokens.pop()
                if ((t is None) or ((t.p != "end"))):
                    raise haxe_Exception.thrown("Unclosed 'else'")
            else:
                t.p = HxString.substr(t.p,4,(len(t.p) - 4))
                eelse = self.parse(tokens)
            return haxe__Template_TemplateExpr.OpIf(e,eif,eelse)
        pos = kwdEnd("foreach")
        if (pos >= 0):
            p = HxString.substr(p,pos,(len(p) - pos))
            e = self.parseExpr(p)
            efor = self.parseBlock(tokens)
            t = tokens.pop()
            if ((t is None) or ((t.p != "end"))):
                raise haxe_Exception.thrown("Unclosed 'foreach'")
            return haxe__Template_TemplateExpr.OpForeach(e,efor)
        _this = haxe_Template.expr_splitter
        _this.matchObj = python_lib_Re.search(_this.pattern,p)
        if (_this.matchObj is not None):
            return haxe__Template_TemplateExpr.OpExpr(self.parseExpr(p))
        return haxe__Template_TemplateExpr.OpVar(p)

    def parseExpr(self,data):
        l = haxe_ds_List()
        expr = data
        while True:
            _this = haxe_Template.expr_splitter
            _this.matchObj = python_lib_Re.search(_this.pattern,data)
            if (not ((_this.matchObj is not None))):
                break
            _this1 = haxe_Template.expr_splitter
            p_pos = _this1.matchObj.start()
            p_len = (_this1.matchObj.end() - _this1.matchObj.start())
            k = (p_pos + p_len)
            if (p_pos != 0):
                l.add(_hx_AnonObject({'p': HxString.substr(data,0,p_pos), 's': True}))
            p = haxe_Template.expr_splitter.matchObj.group(0)
            startIndex = None
            l.add(_hx_AnonObject({'p': p, 's': (((p.find("\"") if ((startIndex is None)) else HxString.indexOfImpl(p,"\"",startIndex))) >= 0)}))
            _this2 = haxe_Template.expr_splitter
            data = HxString.substr(_this2.matchObj.string,_this2.matchObj.end(),None)
        if (len(data) != 0):
            _g_offset = 0
            _g_s = data
            while (_g_offset < len(_g_s)):
                _g1_key = _g_offset
                s = _g_s
                index = _g_offset
                _g_offset = (_g_offset + 1)
                _g1_value = (-1 if ((index >= len(s))) else ord(s[index]))
                i = _g1_key
                c = _g1_value
                if (c != 32):
                    l.add(_hx_AnonObject({'p': HxString.substr(data,i,None), 's': True}))
                    break
        e = None
        try:
            e = self.makeExpr(l)
            if (not l.isEmpty()):
                raise haxe_Exception.thrown(l.first().p)
        except BaseException as _g:
            None
            _g1 = haxe_Exception.caught(_g).unwrap()
            if Std.isOfType(_g1,str):
                s = _g1
                raise haxe_Exception.thrown(((("Unexpected '" + ("null" if s is None else s)) + "' in ") + ("null" if expr is None else expr)))
            else:
                raise _g
        def _hx_local_0():
            try:
                return e()
            except BaseException as _g:
                None
                exc = haxe_Exception.caught(_g).unwrap()
                raise haxe_Exception.thrown(((("Error : " + Std.string(exc)) + " in ") + ("null" if expr is None else expr)))
        return _hx_local_0

    def makeConst(self,v):
        _this = haxe_Template.expr_trim
        _this.matchObj = python_lib_Re.search(_this.pattern,v)
        v = haxe_Template.expr_trim.matchObj.group(1)
        if (HxString.charCodeAt(v,0) == 34):
            _hx_str = HxString.substr(v,1,(len(v) - 2))
            def _hx_local_0():
                return _hx_str
            return _hx_local_0
        _this = haxe_Template.expr_int
        _this.matchObj = python_lib_Re.search(_this.pattern,v)
        if (_this.matchObj is not None):
            i = Std.parseInt(v)
            def _hx_local_1():
                return i
            return _hx_local_1
        _this = haxe_Template.expr_float
        _this.matchObj = python_lib_Re.search(_this.pattern,v)
        if (_this.matchObj is not None):
            f = Std.parseFloat(v)
            def _hx_local_2():
                return f
            return _hx_local_2
        me = self
        def _hx_local_3():
            return me.resolve(v)
        return _hx_local_3

    def makePath(self,e,l):
        p = l.first()
        if ((p is None) or ((p.p != "."))):
            return e
        l.pop()
        field = l.pop()
        if ((field is None) or (not field.s)):
            raise haxe_Exception.thrown(field.p)
        f = field.p
        _this = haxe_Template.expr_trim
        _this.matchObj = python_lib_Re.search(_this.pattern,f)
        f = haxe_Template.expr_trim.matchObj.group(1)
        def _hx_local_1():
            def _hx_local_0():
                return Reflect.field(e(),f)
            return self.makePath(_hx_local_0,l)
        return _hx_local_1()

    def makeExpr(self,l):
        return self.makePath(self.makeExpr2(l),l)

    def skipSpaces(self,l):
        p = l.first()
        while (p is not None):
            _g_offset = 0
            _g_s = p.p
            while (_g_offset < len(_g_s)):
                index = _g_offset
                _g_offset = (_g_offset + 1)
                c = ord(_g_s[index])
                if (c != 32):
                    return
            l.pop()
            p = l.first()

    def makeExpr2(self,l):
        self.skipSpaces(l)
        p = l.pop()
        self.skipSpaces(l)
        if (p is None):
            raise haxe_Exception.thrown("<eof>")
        if p.s:
            return self.makeConst(p.p)
        _g = p.p
        if (_g == "!"):
            e = self.makeExpr(l)
            def _hx_local_0():
                v = e()
                if (v is not None):
                    return (v == False)
                else:
                    return True
            return _hx_local_0
        elif (_g == "("):
            self.skipSpaces(l)
            e1 = self.makeExpr(l)
            self.skipSpaces(l)
            p1 = l.pop()
            if ((p1 is None) or p1.s):
                raise haxe_Exception.thrown(p1)
            if (p1.p == ")"):
                return e1
            self.skipSpaces(l)
            e2 = self.makeExpr(l)
            self.skipSpaces(l)
            p2 = l.pop()
            self.skipSpaces(l)
            if ((p2 is None) or ((p2.p != ")"))):
                raise haxe_Exception.thrown(p2)
            _g = p1.p
            _hx_local_1 = len(_g)
            if (_hx_local_1 == 1):
                if (_g == "*"):
                    def _hx_local_2():
                        return (e1() * e2())
                    return _hx_local_2
                elif (_g == "+"):
                    def _hx_local_3():
                        return python_Boot._add_dynamic(e1(),e2())
                    return _hx_local_3
                elif (_g == "-"):
                    def _hx_local_4():
                        return (e1() - e2())
                    return _hx_local_4
                elif (_g == "/"):
                    def _hx_local_5():
                        return (e1() / e2())
                    return _hx_local_5
                elif (_g == "<"):
                    def _hx_local_6():
                        return (e1() < e2())
                    return _hx_local_6
                elif (_g == ">"):
                    def _hx_local_7():
                        return (e1() > e2())
                    return _hx_local_7
                else:
                    raise haxe_Exception.thrown(("Unknown operation " + HxOverrides.stringOrNull(p1.p)))
            elif (_hx_local_1 == 2):
                if (_g == "!="):
                    def _hx_local_8():
                        return not HxOverrides.eq(e1(),e2())
                    return _hx_local_8
                elif (_g == "&&"):
                    def _hx_local_9():
                        return (e1() and e2())
                    return _hx_local_9
                elif (_g == "<="):
                    def _hx_local_10():
                        return (e1() <= e2())
                    return _hx_local_10
                elif (_g == "=="):
                    def _hx_local_11():
                        return HxOverrides.eq(e1(),e2())
                    return _hx_local_11
                elif (_g == ">="):
                    def _hx_local_12():
                        return (e1() >= e2())
                    return _hx_local_12
                elif (_g == "||"):
                    def _hx_local_13():
                        return (e1() or e2())
                    return _hx_local_13
                else:
                    raise haxe_Exception.thrown(("Unknown operation " + HxOverrides.stringOrNull(p1.p)))
            else:
                raise haxe_Exception.thrown(("Unknown operation " + HxOverrides.stringOrNull(p1.p)))
        elif (_g == "-"):
            e3 = self.makeExpr(l)
            def _hx_local_14():
                return -e3()
            return _hx_local_14
        else:
            pass
        raise haxe_Exception.thrown(p.p)

    def run(self,e):
        tmp = e.index
        if (tmp == 0):
            v = e.params[0]
            _this = self.buf
            s = Std.string(Std.string(self.resolve(v)))
            _this.b.write(s)
        elif (tmp == 1):
            e1 = e.params[0]
            _this = self.buf
            s = Std.string(Std.string(e1()))
            _this.b.write(s)
        elif (tmp == 2):
            e1 = e.params[0]
            eif = e.params[1]
            eelse = e.params[2]
            v = e1()
            if ((v is None) or ((v == False))):
                if (eelse is not None):
                    self.run(eelse)
            else:
                self.run(eif)
        elif (tmp == 3):
            _hx_str = e.params[0]
            _this = self.buf
            s = Std.string(_hx_str)
            _this.b.write(s)
        elif (tmp == 4):
            l = e.params[0]
            _g_head = l.h
            while (_g_head is not None):
                val = _g_head.item
                _g_head = _g_head.next
                e1 = val
                self.run(e1)
        elif (tmp == 5):
            e1 = e.params[0]
            loop = e.params[1]
            v = e1()
            try:
                x = Reflect.field(v,"iterator")()
                if (Reflect.field(x,"hasNext") is None):
                    raise haxe_Exception.thrown(None)
                v = x
            except BaseException as _g:
                None
                try:
                    if (Reflect.field(v,"hasNext") is None):
                        raise haxe_Exception.thrown(None)
                except BaseException as _g:
                    raise haxe_Exception.thrown(("Cannot iter on " + Std.string(v)))
            self.stack.push(self.context)
            v1 = v
            ctx = v1
            while ctx.hasNext():
                ctx1 = ctx.next()
                self.context = ctx1
                self.run(loop)
            self.context = self.stack.pop()
        elif (tmp == 6):
            m = e.params[0]
            params = e.params[1]
            v = Reflect.field(self.macros,m)
            pl = list()
            old = self.buf
            pl.append(self.resolve)
            _g_head = params.h
            while (_g_head is not None):
                val = _g_head.item
                _g_head = _g_head.next
                p = val
                if (p.index == 0):
                    v1 = p.params[0]
                    x = self.resolve(v1)
                    pl.append(x)
                else:
                    self.buf = StringBuf()
                    self.run(p)
                    x1 = self.buf.b.getvalue()
                    pl.append(x1)
            self.buf = old
            try:
                _this = self.buf
                s = Std.string(Std.string(Reflect.callMethod(self.macros,v,pl)))
                _this.b.write(s)
            except BaseException as _g:
                None
                e = haxe_Exception.caught(_g).unwrap()
                plstr = None
                try:
                    plstr = ",".join([python_Boot.toString1(x1,'') for x1 in pl])
                except BaseException as _g:
                    plstr = "???"
                msg = (((((("Macro call " + ("null" if m is None else m)) + "(") + ("null" if plstr is None else plstr)) + ") failed (") + Std.string(e)) + ")")
                raise haxe_Exception.thrown(msg)
        else:
            pass

haxe_Template._hx_class = haxe_Template


class haxe_ValueException(haxe_Exception):
    _hx_class_name = "haxe.ValueException"
    __slots__ = ("value",)
    _hx_fields = ["value"]
    _hx_methods = ["unwrap"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_Exception


    def __init__(self,value,previous = None,native = None):
        self.value = None
        super().__init__(Std.string(value),previous,native)
        self.value = value

    def unwrap(self):
        return self.value

haxe_ValueException._hx_class = haxe_ValueException


class haxe_crypto_BaseCode:
    _hx_class_name = "haxe.crypto.BaseCode"
    __slots__ = ("base", "nbits", "tbl")
    _hx_fields = ["base", "nbits", "tbl"]
    _hx_methods = ["encodeBytes", "initTable", "decodeBytes"]

    def __init__(self,base):
        self.tbl = None
        _hx_len = base.length
        nbits = 1
        while (_hx_len > ((1 << nbits))):
            nbits = (nbits + 1)
        if ((nbits > 8) or ((_hx_len != ((1 << nbits))))):
            raise haxe_Exception.thrown("BaseCode : base length must be a power of two.")
        self.base = base
        self.nbits = nbits

    def encodeBytes(self,b):
        nbits = self.nbits
        base = self.base
        x = ((b.length * 8) / nbits)
        size = None
        try:
            size = int(x)
        except BaseException as _g:
            None
            size = None
        out = haxe_io_Bytes.alloc((size + ((0 if ((HxOverrides.mod((b.length * 8), nbits) == 0)) else 1))))
        buf = 0
        curbits = 0
        mask = (((1 << nbits)) - 1)
        pin = 0
        pout = 0
        while (pout < size):
            while (curbits < nbits):
                curbits = (curbits + 8)
                buf = (buf << 8)
                pos = pin
                pin = (pin + 1)
                buf = (buf | b.b[pos])
            curbits = (curbits - nbits)
            pos1 = pout
            pout = (pout + 1)
            v = base.b[((buf >> curbits) & mask)]
            out.b[pos1] = (v & 255)
        if (curbits > 0):
            pos = pout
            pout = (pout + 1)
            v = base.b[((buf << ((nbits - curbits))) & mask)]
            out.b[pos] = (v & 255)
        return out

    def initTable(self):
        tbl = list()
        _g = 0
        while (_g < 256):
            i = _g
            _g = (_g + 1)
            python_internal_ArrayImpl._set(tbl, i, -1)
        _g = 0
        _g1 = self.base.length
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            python_internal_ArrayImpl._set(tbl, self.base.b[i], i)
        self.tbl = tbl

    def decodeBytes(self,b):
        nbits = self.nbits
        base = self.base
        if (self.tbl is None):
            self.initTable()
        tbl = self.tbl
        size = ((b.length * nbits) >> 3)
        out = haxe_io_Bytes.alloc(size)
        buf = 0
        curbits = 0
        pin = 0
        pout = 0
        while (pout < size):
            while (curbits < 8):
                curbits = (curbits + nbits)
                buf = (buf << nbits)
                pos = pin
                pin = (pin + 1)
                i = python_internal_ArrayImpl._get(tbl, b.b[pos])
                if (i == -1):
                    raise haxe_Exception.thrown("BaseCode : invalid encoded char")
                buf = (buf | i)
            curbits = (curbits - 8)
            pos1 = pout
            pout = (pout + 1)
            out.b[pos1] = (((buf >> curbits) & 255) & 255)
        return out

haxe_crypto_BaseCode._hx_class = haxe_crypto_BaseCode


class haxe_crypto_Crc32:
    _hx_class_name = "haxe.crypto.Crc32"
    __slots__ = ()
    _hx_statics = ["make"]

    @staticmethod
    def make(data):
        c_crc = -1
        b = data.b
        _g = 0
        _g1 = data.length
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            tmp = (((c_crc ^ b[i])) & 255)
            tmp = (HxOverrides.rshift(tmp, 1) ^ ((-((tmp & 1)) & -306674912)))
            tmp = (HxOverrides.rshift(tmp, 1) ^ ((-((tmp & 1)) & -306674912)))
            tmp = (HxOverrides.rshift(tmp, 1) ^ ((-((tmp & 1)) & -306674912)))
            tmp = (HxOverrides.rshift(tmp, 1) ^ ((-((tmp & 1)) & -306674912)))
            tmp = (HxOverrides.rshift(tmp, 1) ^ ((-((tmp & 1)) & -306674912)))
            tmp = (HxOverrides.rshift(tmp, 1) ^ ((-((tmp & 1)) & -306674912)))
            tmp = (HxOverrides.rshift(tmp, 1) ^ ((-((tmp & 1)) & -306674912)))
            tmp = (HxOverrides.rshift(tmp, 1) ^ ((-((tmp & 1)) & -306674912)))
            c_crc = (HxOverrides.rshift(c_crc, 8) ^ tmp)
        return (c_crc ^ -1)
haxe_crypto_Crc32._hx_class = haxe_crypto_Crc32


class haxe_ds_List:
    _hx_class_name = "haxe.ds.List"
    __slots__ = ("h", "q", "length")
    _hx_fields = ["h", "q", "length"]
    _hx_methods = ["add", "push", "first", "pop", "isEmpty", "toString"]

    def __init__(self):
        self.q = None
        self.h = None
        self.length = 0

    def add(self,item):
        x = haxe_ds__List_ListNode(item,None)
        if (self.h is None):
            self.h = x
        else:
            self.q.next = x
        self.q = x
        _hx_local_0 = self
        _hx_local_1 = _hx_local_0.length
        _hx_local_0.length = (_hx_local_1 + 1)
        _hx_local_1

    def push(self,item):
        x = haxe_ds__List_ListNode(item,self.h)
        self.h = x
        if (self.q is None):
            self.q = x
        _hx_local_0 = self
        _hx_local_1 = _hx_local_0.length
        _hx_local_0.length = (_hx_local_1 + 1)
        _hx_local_1

    def first(self):
        if (self.h is None):
            return None
        else:
            return self.h.item

    def pop(self):
        if (self.h is None):
            return None
        x = self.h.item
        self.h = self.h.next
        if (self.h is None):
            self.q = None
        _hx_local_0 = self
        _hx_local_1 = _hx_local_0.length
        _hx_local_0.length = (_hx_local_1 - 1)
        _hx_local_1
        return x

    def isEmpty(self):
        return (self.h is None)

    def toString(self):
        s_b = python_lib_io_StringIO()
        first = True
        l = self.h
        s_b.write("{")
        while (l is not None):
            if first:
                first = False
            else:
                s_b.write(", ")
            s_b.write(Std.string(Std.string(l.item)))
            l = l.next
        s_b.write("}")
        return s_b.getvalue()

haxe_ds_List._hx_class = haxe_ds_List


class haxe_ds__List_ListNode:
    _hx_class_name = "haxe.ds._List.ListNode"
    __slots__ = ("item", "next")
    _hx_fields = ["item", "next"]

    def __init__(self,item,next):
        self.item = item
        self.next = next

haxe_ds__List_ListNode._hx_class = haxe_ds__List_ListNode


class haxe_ds_StringMap:
    _hx_class_name = "haxe.ds.StringMap"
    __slots__ = ("h",)
    _hx_fields = ["h"]
    _hx_methods = ["remove", "keys"]
    _hx_interfaces = [haxe_IMap]

    def __init__(self):
        self.h = dict()

    def remove(self,key):
        has = (key in self.h)
        if has:
            del self.h[key]
        return has

    def keys(self):
        return python_HaxeIterator(iter(self.h.keys()))

haxe_ds_StringMap._hx_class = haxe_ds_StringMap


class haxe_exceptions_PosException(haxe_Exception):
    _hx_class_name = "haxe.exceptions.PosException"
    __slots__ = ("posInfos",)
    _hx_fields = ["posInfos"]
    _hx_methods = ["toString"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_Exception


    def __init__(self,message,previous = None,pos = None):
        self.posInfos = None
        super().__init__(message,previous)
        if (pos is None):
            self.posInfos = _hx_AnonObject({'fileName': "(unknown)", 'lineNumber': 0, 'className': "(unknown)", 'methodName': "(unknown)"})
        else:
            self.posInfos = pos

    def toString(self):
        return ((((((((("" + HxOverrides.stringOrNull(super().toString())) + " in ") + HxOverrides.stringOrNull(self.posInfos.className)) + ".") + HxOverrides.stringOrNull(self.posInfos.methodName)) + " at ") + HxOverrides.stringOrNull(self.posInfos.fileName)) + ":") + Std.string(self.posInfos.lineNumber))

haxe_exceptions_PosException._hx_class = haxe_exceptions_PosException


class haxe_exceptions_NotImplementedException(haxe_exceptions_PosException):
    _hx_class_name = "haxe.exceptions.NotImplementedException"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_exceptions_PosException


    def __init__(self,message = None,previous = None,pos = None):
        if (message is None):
            message = "Not implemented"
        super().__init__(message,previous,pos)
haxe_exceptions_NotImplementedException._hx_class = haxe_exceptions_NotImplementedException


class haxe_format_JsonPrinter:
    _hx_class_name = "haxe.format.JsonPrinter"
    __slots__ = ("buf", "replacer", "indent", "pretty", "nind")
    _hx_fields = ["buf", "replacer", "indent", "pretty", "nind"]
    _hx_methods = ["write", "classString", "fieldsString", "quote"]
    _hx_statics = ["print"]

    def __init__(self,replacer,space):
        self.replacer = replacer
        self.indent = space
        self.pretty = (space is not None)
        self.nind = 0
        self.buf = StringBuf()

    def write(self,k,v):
        if (self.replacer is not None):
            v = self.replacer(k,v)
        _g = Type.typeof(v)
        tmp = _g.index
        if (tmp == 0):
            self.buf.b.write("null")
        elif (tmp == 1):
            _this = self.buf
            s = Std.string(v)
            _this.b.write(s)
        elif (tmp == 2):
            f = v
            v1 = (Std.string(v) if ((((f != Math.POSITIVE_INFINITY) and ((f != Math.NEGATIVE_INFINITY))) and (not python_lib_Math.isnan(f)))) else "null")
            _this = self.buf
            s = Std.string(v1)
            _this.b.write(s)
        elif (tmp == 3):
            _this = self.buf
            s = Std.string(v)
            _this.b.write(s)
        elif (tmp == 4):
            self.fieldsString(v,python_Boot.fields(v))
        elif (tmp == 5):
            self.buf.b.write("\"<fun>\"")
        elif (tmp == 6):
            c = _g.params[0]
            if (c == str):
                self.quote(v)
            elif (c == list):
                v1 = v
                _this = self.buf
                s = "".join(map(chr,[91]))
                _this.b.write(s)
                _hx_len = len(v1)
                last = (_hx_len - 1)
                _g1 = 0
                _g2 = _hx_len
                while (_g1 < _g2):
                    i = _g1
                    _g1 = (_g1 + 1)
                    if (i > 0):
                        _this = self.buf
                        s = "".join(map(chr,[44]))
                        _this.b.write(s)
                    else:
                        _hx_local_0 = self
                        _hx_local_1 = _hx_local_0.nind
                        _hx_local_0.nind = (_hx_local_1 + 1)
                        _hx_local_1
                    if self.pretty:
                        _this1 = self.buf
                        s1 = "".join(map(chr,[10]))
                        _this1.b.write(s1)
                    if self.pretty:
                        v2 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
                        _this2 = self.buf
                        s2 = Std.string(v2)
                        _this2.b.write(s2)
                    self.write(i,(v1[i] if i >= 0 and i < len(v1) else None))
                    if (i == last):
                        _hx_local_2 = self
                        _hx_local_3 = _hx_local_2.nind
                        _hx_local_2.nind = (_hx_local_3 - 1)
                        _hx_local_3
                        if self.pretty:
                            _this3 = self.buf
                            s3 = "".join(map(chr,[10]))
                            _this3.b.write(s3)
                        if self.pretty:
                            v3 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
                            _this4 = self.buf
                            s4 = Std.string(v3)
                            _this4.b.write(s4)
                _this = self.buf
                s = "".join(map(chr,[93]))
                _this.b.write(s)
            elif (c == haxe_ds_StringMap):
                v1 = v
                o = _hx_AnonObject({})
                k = v1.keys()
                while k.hasNext():
                    k1 = k.next()
                    value = v1.h.get(k1,None)
                    setattr(o,(("_hx_" + k1) if ((k1 in python_Boot.keywords)) else (("_hx_" + k1) if (((((len(k1) > 2) and ((ord(k1[0]) == 95))) and ((ord(k1[1]) == 95))) and ((ord(k1[(len(k1) - 1)]) != 95)))) else k1)),value)
                v1 = o
                self.fieldsString(v1,python_Boot.fields(v1))
            elif (c == Date):
                v1 = v
                self.quote(v1.toString())
            else:
                self.classString(v)
        elif (tmp == 7):
            _g1 = _g.params[0]
            i = v.index
            _this = self.buf
            s = Std.string(i)
            _this.b.write(s)
        elif (tmp == 8):
            self.buf.b.write("\"???\"")
        else:
            pass

    def classString(self,v):
        self.fieldsString(v,python_Boot.getInstanceFields(Type.getClass(v)))

    def fieldsString(self,v,fields):
        _this = self.buf
        s = "".join(map(chr,[123]))
        _this.b.write(s)
        _hx_len = len(fields)
        last = (_hx_len - 1)
        first = True
        _g = 0
        _g1 = _hx_len
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            f = (fields[i] if i >= 0 and i < len(fields) else None)
            value = Reflect.field(v,f)
            if Reflect.isFunction(value):
                continue
            if first:
                _hx_local_0 = self
                _hx_local_1 = _hx_local_0.nind
                _hx_local_0.nind = (_hx_local_1 + 1)
                _hx_local_1
                first = False
            else:
                _this = self.buf
                s = "".join(map(chr,[44]))
                _this.b.write(s)
            if self.pretty:
                _this1 = self.buf
                s1 = "".join(map(chr,[10]))
                _this1.b.write(s1)
            if self.pretty:
                v1 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
                _this2 = self.buf
                s2 = Std.string(v1)
                _this2.b.write(s2)
            self.quote(f)
            _this3 = self.buf
            s3 = "".join(map(chr,[58]))
            _this3.b.write(s3)
            if self.pretty:
                _this4 = self.buf
                s4 = "".join(map(chr,[32]))
                _this4.b.write(s4)
            self.write(f,value)
            if (i == last):
                _hx_local_2 = self
                _hx_local_3 = _hx_local_2.nind
                _hx_local_2.nind = (_hx_local_3 - 1)
                _hx_local_3
                if self.pretty:
                    _this5 = self.buf
                    s5 = "".join(map(chr,[10]))
                    _this5.b.write(s5)
                if self.pretty:
                    v2 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
                    _this6 = self.buf
                    s6 = Std.string(v2)
                    _this6.b.write(s6)
        _this = self.buf
        s = "".join(map(chr,[125]))
        _this.b.write(s)

    def quote(self,s):
        _this = self.buf
        s1 = "".join(map(chr,[34]))
        _this.b.write(s1)
        i = 0
        length = len(s)
        while (i < length):
            index = i
            i = (i + 1)
            c = ord(s[index])
            c1 = c
            if (c1 == 8):
                self.buf.b.write("\\b")
            elif (c1 == 9):
                self.buf.b.write("\\t")
            elif (c1 == 10):
                self.buf.b.write("\\n")
            elif (c1 == 12):
                self.buf.b.write("\\f")
            elif (c1 == 13):
                self.buf.b.write("\\r")
            elif (c1 == 34):
                self.buf.b.write("\\\"")
            elif (c1 == 92):
                self.buf.b.write("\\\\")
            else:
                _this = self.buf
                s1 = "".join(map(chr,[c]))
                _this.b.write(s1)
        _this = self.buf
        s = "".join(map(chr,[34]))
        _this.b.write(s)

    @staticmethod
    def print(o,replacer = None,space = None):
        printer = haxe_format_JsonPrinter(replacer,space)
        printer.write("",o)
        return printer.buf.b.getvalue()

haxe_format_JsonPrinter._hx_class = haxe_format_JsonPrinter


class haxe_io_Bytes:
    _hx_class_name = "haxe.io.Bytes"
    __slots__ = ("length", "b")
    _hx_fields = ["length", "b"]
    _hx_methods = ["blit", "getString", "toString"]
    _hx_statics = ["alloc", "ofString", "ofData"]

    def __init__(self,length,b):
        self.length = length
        self.b = b

    def blit(self,pos,src,srcpos,_hx_len):
        if (((((pos < 0) or ((srcpos < 0))) or ((_hx_len < 0))) or (((pos + _hx_len) > self.length))) or (((srcpos + _hx_len) > src.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        self.b[pos:pos+_hx_len] = src.b[srcpos:srcpos+_hx_len]

    def getString(self,pos,_hx_len,encoding = None):
        tmp = (encoding is None)
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > self.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        return self.b[pos:pos+_hx_len].decode('UTF-8','replace')

    def toString(self):
        return self.getString(0,self.length)

    @staticmethod
    def alloc(length):
        return haxe_io_Bytes(length,bytearray(length))

    @staticmethod
    def ofString(s,encoding = None):
        b = bytearray(s,"UTF-8")
        return haxe_io_Bytes(len(b),b)

    @staticmethod
    def ofData(b):
        return haxe_io_Bytes(len(b),b)

haxe_io_Bytes._hx_class = haxe_io_Bytes


class haxe_io_BytesBuffer:
    _hx_class_name = "haxe.io.BytesBuffer"
    __slots__ = ("b",)
    _hx_fields = ["b"]
    _hx_methods = ["getBytes"]

    def __init__(self):
        self.b = bytearray()

    def getBytes(self):
        _hx_bytes = haxe_io_Bytes(len(self.b),self.b)
        self.b = None
        return _hx_bytes

haxe_io_BytesBuffer._hx_class = haxe_io_BytesBuffer


class haxe_io_Output:
    _hx_class_name = "haxe.io.Output"
    __slots__ = ("bigEndian",)
    _hx_fields = ["bigEndian"]
    _hx_methods = ["writeByte", "writeBytes", "set_bigEndian", "write", "writeFullBytes", "writeUInt16", "writeInt32", "writeString"]

    def writeByte(self,c):
        raise haxe_exceptions_NotImplementedException(None,None,_hx_AnonObject({'fileName': "haxe/io/Output.hx", 'lineNumber': 47, 'className': "haxe.io.Output", 'methodName': "writeByte"}))

    def writeBytes(self,s,pos,_hx_len):
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > s.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        b = s.b
        k = _hx_len
        while (k > 0):
            self.writeByte(b[pos])
            pos = (pos + 1)
            k = (k - 1)
        return _hx_len

    def set_bigEndian(self,b):
        self.bigEndian = b
        return b

    def write(self,s):
        l = s.length
        p = 0
        while (l > 0):
            k = self.writeBytes(s,p,l)
            if (k == 0):
                raise haxe_Exception.thrown(haxe_io_Error.Blocked)
            p = (p + k)
            l = (l - k)

    def writeFullBytes(self,s,pos,_hx_len):
        while (_hx_len > 0):
            k = self.writeBytes(s,pos,_hx_len)
            pos = (pos + k)
            _hx_len = (_hx_len - k)

    def writeUInt16(self,x):
        if ((x < 0) or ((x >= 65536))):
            raise haxe_Exception.thrown(haxe_io_Error.Overflow)
        if self.bigEndian:
            self.writeByte((x >> 8))
            self.writeByte((x & 255))
        else:
            self.writeByte((x & 255))
            self.writeByte((x >> 8))

    def writeInt32(self,x):
        if self.bigEndian:
            self.writeByte(HxOverrides.rshift(x, 24))
            self.writeByte(((x >> 16) & 255))
            self.writeByte(((x >> 8) & 255))
            self.writeByte((x & 255))
        else:
            self.writeByte((x & 255))
            self.writeByte(((x >> 8) & 255))
            self.writeByte(((x >> 16) & 255))
            self.writeByte(HxOverrides.rshift(x, 24))

    def writeString(self,s,encoding = None):
        b = haxe_io_Bytes.ofString(s,encoding)
        self.writeFullBytes(b,0,b.length)

haxe_io_Output._hx_class = haxe_io_Output


class haxe_io_BytesOutput(haxe_io_Output):
    _hx_class_name = "haxe.io.BytesOutput"
    __slots__ = ("b",)
    _hx_fields = ["b"]
    _hx_methods = ["writeByte", "writeBytes", "getBytes"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Output


    def __init__(self):
        self.b = haxe_io_BytesBuffer()
        self.set_bigEndian(False)

    def writeByte(self,c):
        self.b.b.append(c)

    def writeBytes(self,buf,pos,_hx_len):
        _this = self.b
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > buf.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        _this.b.extend(buf.b[pos:(pos + _hx_len)])
        return _hx_len

    def getBytes(self):
        return self.b.getBytes()

haxe_io_BytesOutput._hx_class = haxe_io_BytesOutput

class haxe_io_Encoding(Enum):
    __slots__ = ()
    _hx_class_name = "haxe.io.Encoding"
    _hx_constructs = ["UTF8", "RawNative"]
haxe_io_Encoding.UTF8 = haxe_io_Encoding("UTF8", 0, ())
haxe_io_Encoding.RawNative = haxe_io_Encoding("RawNative", 1, ())
haxe_io_Encoding._hx_class = haxe_io_Encoding


class haxe_io_Eof:
    _hx_class_name = "haxe.io.Eof"
    __slots__ = ()
    _hx_methods = ["toString"]

    def __init__(self):
        pass

    def toString(self):
        return "Eof"

haxe_io_Eof._hx_class = haxe_io_Eof

class haxe_io_Error(Enum):
    __slots__ = ()
    _hx_class_name = "haxe.io.Error"
    _hx_constructs = ["Blocked", "Overflow", "OutsideBounds", "Custom"]

    @staticmethod
    def Custom(e):
        return haxe_io_Error("Custom", 3, (e,))
haxe_io_Error.Blocked = haxe_io_Error("Blocked", 0, ())
haxe_io_Error.Overflow = haxe_io_Error("Overflow", 1, ())
haxe_io_Error.OutsideBounds = haxe_io_Error("OutsideBounds", 2, ())
haxe_io_Error._hx_class = haxe_io_Error


class haxe_io_Input:
    _hx_class_name = "haxe.io.Input"
    __slots__ = ("bigEndian",)
    _hx_fields = ["bigEndian"]
    _hx_methods = ["readByte", "readBytes", "set_bigEndian", "readAll", "readLine"]

    def readByte(self):
        raise haxe_exceptions_NotImplementedException(None,None,_hx_AnonObject({'fileName': "haxe/io/Input.hx", 'lineNumber': 53, 'className': "haxe.io.Input", 'methodName': "readByte"}))

    def readBytes(self,s,pos,_hx_len):
        k = _hx_len
        b = s.b
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > s.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        try:
            while (k > 0):
                b[pos] = self.readByte()
                pos = (pos + 1)
                k = (k - 1)
        except BaseException as _g:
            None
            if (not Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof)):
                raise _g
        return (_hx_len - k)

    def set_bigEndian(self,b):
        self.bigEndian = b
        return b

    def readAll(self,bufsize = None):
        if (bufsize is None):
            bufsize = 16384
        buf = haxe_io_Bytes.alloc(bufsize)
        total = haxe_io_BytesBuffer()
        try:
            while True:
                _hx_len = self.readBytes(buf,0,bufsize)
                if (_hx_len == 0):
                    raise haxe_Exception.thrown(haxe_io_Error.Blocked)
                if ((_hx_len < 0) or ((_hx_len > buf.length))):
                    raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
                total.b.extend(buf.b[0:_hx_len])
        except BaseException as _g:
            None
            if (not Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof)):
                raise _g
        return total.getBytes()

    def readLine(self):
        buf = haxe_io_BytesBuffer()
        last = None
        s = None
        try:
            while True:
                last = self.readByte()
                if (not ((last != 10))):
                    break
                buf.b.append(last)
            s = buf.getBytes().toString()
            if (HxString.charCodeAt(s,(len(s) - 1)) == 13):
                s = HxString.substr(s,0,-1)
        except BaseException as _g:
            None
            _g1 = haxe_Exception.caught(_g).unwrap()
            if Std.isOfType(_g1,haxe_io_Eof):
                e = _g1
                s = buf.getBytes().toString()
                if (len(s) == 0):
                    raise haxe_Exception.thrown(e)
            else:
                raise _g
        return s

haxe_io_Input._hx_class = haxe_io_Input


class haxe_io_Path:
    _hx_class_name = "haxe.io.Path"
    __slots__ = ("dir", "file", "ext", "backslash")
    _hx_fields = ["dir", "file", "ext", "backslash"]
    _hx_methods = ["toString"]
    _hx_statics = ["withoutExtension", "withoutDirectory", "directory", "extension", "withExtension", "normalize", "addTrailingSlash", "removeTrailingSlashes"]

    def __init__(self,path):
        self.backslash = None
        self.ext = None
        self.file = None
        self.dir = None
        path1 = path
        _hx_local_0 = len(path1)
        if (_hx_local_0 == 1):
            if (path1 == "."):
                self.dir = path
                self.file = ""
                return
        elif (_hx_local_0 == 2):
            if (path1 == ".."):
                self.dir = path
                self.file = ""
                return
        else:
            pass
        startIndex = None
        c1 = None
        if (startIndex is None):
            c1 = path.rfind("/", 0, len(path))
        else:
            i = path.rfind("/", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("/"))) if ((i == -1)) else (i + 1))
            check = path.find("/", startLeft, len(path))
            c1 = (check if (((check > i) and ((check <= startIndex)))) else i)
        startIndex = None
        c2 = None
        if (startIndex is None):
            c2 = path.rfind("\\", 0, len(path))
        else:
            i = path.rfind("\\", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("\\"))) if ((i == -1)) else (i + 1))
            check = path.find("\\", startLeft, len(path))
            c2 = (check if (((check > i) and ((check <= startIndex)))) else i)
        if (c1 < c2):
            self.dir = HxString.substr(path,0,c2)
            path = HxString.substr(path,(c2 + 1),None)
            self.backslash = True
        elif (c2 < c1):
            self.dir = HxString.substr(path,0,c1)
            path = HxString.substr(path,(c1 + 1),None)
        else:
            self.dir = None
        startIndex = None
        cp = None
        if (startIndex is None):
            cp = path.rfind(".", 0, len(path))
        else:
            i = path.rfind(".", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("."))) if ((i == -1)) else (i + 1))
            check = path.find(".", startLeft, len(path))
            cp = (check if (((check > i) and ((check <= startIndex)))) else i)
        if (cp != -1):
            self.ext = HxString.substr(path,(cp + 1),None)
            self.file = HxString.substr(path,0,cp)
        else:
            self.ext = None
            self.file = path

    def toString(self):
        return ((HxOverrides.stringOrNull((("" if ((self.dir is None)) else (HxOverrides.stringOrNull(self.dir) + HxOverrides.stringOrNull((("\\" if (self.backslash) else "/"))))))) + HxOverrides.stringOrNull(self.file)) + HxOverrides.stringOrNull((("" if ((self.ext is None)) else ("." + HxOverrides.stringOrNull(self.ext))))))

    @staticmethod
    def withoutExtension(path):
        s = haxe_io_Path(path)
        s.ext = None
        return s.toString()

    @staticmethod
    def withoutDirectory(path):
        s = haxe_io_Path(path)
        s.dir = None
        return s.toString()

    @staticmethod
    def directory(path):
        s = haxe_io_Path(path)
        if (s.dir is None):
            return ""
        return s.dir

    @staticmethod
    def extension(path):
        s = haxe_io_Path(path)
        if (s.ext is None):
            return ""
        return s.ext

    @staticmethod
    def withExtension(path,ext):
        s = haxe_io_Path(path)
        s.ext = ext
        return s.toString()

    @staticmethod
    def normalize(path):
        slash = "/"
        _this = path.split("\\")
        path = slash.join([python_Boot.toString1(x1,'') for x1 in _this])
        if (path == slash):
            return slash
        target = []
        _g = 0
        _g1 = (list(path) if ((slash == "")) else path.split(slash))
        while (_g < len(_g1)):
            token = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            if (((token == "..") and ((len(target) > 0))) and ((python_internal_ArrayImpl._get(target, (len(target) - 1)) != ".."))):
                if (len(target) != 0):
                    target.pop()
            elif (token == ""):
                if ((len(target) > 0) or ((HxString.charCodeAt(path,0) == 47))):
                    target.append(token)
            elif (token != "."):
                target.append(token)
        tmp = slash.join([python_Boot.toString1(x1,'') for x1 in target])
        acc_b = python_lib_io_StringIO()
        colon = False
        slashes = False
        _g = 0
        _g1 = len(tmp)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            _g2 = (-1 if ((i >= len(tmp))) else ord(tmp[i]))
            _g3 = _g2
            if (_g3 == 47):
                if (not colon):
                    slashes = True
                else:
                    i1 = _g2
                    colon = False
                    if slashes:
                        acc_b.write("/")
                        slashes = False
                    acc_b.write("".join(map(chr,[i1])))
            elif (_g3 == 58):
                acc_b.write(":")
                colon = True
            else:
                i2 = _g2
                colon = False
                if slashes:
                    acc_b.write("/")
                    slashes = False
                acc_b.write("".join(map(chr,[i2])))
        return acc_b.getvalue()

    @staticmethod
    def addTrailingSlash(path):
        if (len(path) == 0):
            return "/"
        startIndex = None
        c1 = None
        if (startIndex is None):
            c1 = path.rfind("/", 0, len(path))
        else:
            i = path.rfind("/", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("/"))) if ((i == -1)) else (i + 1))
            check = path.find("/", startLeft, len(path))
            c1 = (check if (((check > i) and ((check <= startIndex)))) else i)
        startIndex = None
        c2 = None
        if (startIndex is None):
            c2 = path.rfind("\\", 0, len(path))
        else:
            i = path.rfind("\\", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("\\"))) if ((i == -1)) else (i + 1))
            check = path.find("\\", startLeft, len(path))
            c2 = (check if (((check > i) and ((check <= startIndex)))) else i)
        if (c1 < c2):
            if (c2 != ((len(path) - 1))):
                return (("null" if path is None else path) + "\\")
            else:
                return path
        elif (c1 != ((len(path) - 1))):
            return (("null" if path is None else path) + "/")
        else:
            return path

    @staticmethod
    def removeTrailingSlashes(path):
        while True:
            _g = HxString.charCodeAt(path,(len(path) - 1))
            if (_g is None):
                break
            else:
                _g1 = _g
                if ((_g1 == 92) or ((_g1 == 47))):
                    path = HxString.substr(path,0,-1)
                else:
                    break
        return path

haxe_io_Path._hx_class = haxe_io_Path


class haxe_iterators_ArrayKeyValueIterator:
    _hx_class_name = "haxe.iterators.ArrayKeyValueIterator"
    __slots__ = ("current", "array")
    _hx_fields = ["current", "array"]
    _hx_methods = ["hasNext", "next"]

    def __init__(self,array):
        self.current = 0
        self.array = array

    def hasNext(self):
        return (self.current < len(self.array))

    def next(self):
        def _hx_local_3():
            def _hx_local_2():
                _hx_local_0 = self
                _hx_local_1 = _hx_local_0.current
                _hx_local_0.current = (_hx_local_1 + 1)
                return _hx_local_1
            return _hx_AnonObject({'value': python_internal_ArrayImpl._get(self.array, self.current), 'key': _hx_local_2()})
        return _hx_local_3()

haxe_iterators_ArrayKeyValueIterator._hx_class = haxe_iterators_ArrayKeyValueIterator

class haxe_zip_ExtraField(Enum):
    __slots__ = ()
    _hx_class_name = "haxe.zip.ExtraField"
    _hx_constructs = ["FUnknown", "FInfoZipUnicodePath", "FUtf8"]

    @staticmethod
    def FUnknown(tag,bytes):
        return haxe_zip_ExtraField("FUnknown", 0, (tag,bytes))

    @staticmethod
    def FInfoZipUnicodePath(name,crc):
        return haxe_zip_ExtraField("FInfoZipUnicodePath", 1, (name,crc))
haxe_zip_ExtraField.FUtf8 = haxe_zip_ExtraField("FUtf8", 2, ())
haxe_zip_ExtraField._hx_class = haxe_zip_ExtraField


class haxe_zip_Writer:
    _hx_class_name = "haxe.zip.Writer"
    __slots__ = ("o", "files")
    _hx_fields = ["o", "files"]
    _hx_methods = ["writeZipDate", "writeEntryHeader", "write", "writeCDR"]

    def __init__(self,o):
        self.o = o
        self.files = haxe_ds_List()

    def writeZipDate(self,date):
        hour = date.date.hour
        _hx_min = date.date.minute
        sec = (date.date.second >> 1)
        self.o.writeUInt16((((hour << 11) | ((_hx_min << 5))) | sec))
        year = (date.date.year - 1980)
        month = ((date.date.month - 1) + 1)
        day = date.date.day
        self.o.writeUInt16((((year << 9) | ((month << 5))) | day))

    def writeEntryHeader(self,f):
        o = self.o
        flags = 0
        if (Reflect.field(f,"extraFields") is not None):
            _g_head = Reflect.field(f,"extraFields").h
            while (_g_head is not None):
                val = _g_head.item
                _g_head = _g_head.next
                e = val
                if (e.index == 2):
                    flags = (flags | 2048)
        o.writeInt32(67324752)
        o.writeUInt16(20)
        o.writeUInt16(flags)
        if (f.data is None):
            f.fileSize = 0
            f.dataSize = 0
            f.crc32 = 0
            f.compressed = False
            f.data = haxe_io_Bytes.alloc(0)
        else:
            if (f.crc32 is None):
                if f.compressed:
                    raise haxe_Exception.thrown("CRC32 must be processed before compression")
                f.crc32 = haxe_crypto_Crc32.make(f.data)
            if (not f.compressed):
                f.fileSize = f.data.length
            f.dataSize = f.data.length
        o.writeUInt16((8 if (f.compressed) else 0))
        self.writeZipDate(f.fileTime)
        o.writeInt32(f.crc32)
        o.writeInt32(f.dataSize)
        o.writeInt32(f.fileSize)
        o.writeUInt16(len(f.fileName))
        e = haxe_io_BytesOutput()
        if (Reflect.field(f,"extraFields") is not None):
            _g_head = Reflect.field(f,"extraFields").h
            while (_g_head is not None):
                val = _g_head.item
                _g_head = _g_head.next
                f1 = val
                tmp = f1.index
                if (tmp == 0):
                    tag = f1.params[0]
                    _hx_bytes = f1.params[1]
                    e.writeUInt16(tag)
                    e.writeUInt16(_hx_bytes.length)
                    e.write(_hx_bytes)
                elif (tmp == 1):
                    name = f1.params[0]
                    crc = f1.params[1]
                    namebytes = haxe_io_Bytes.ofString(name)
                    e.writeUInt16(28789)
                    e.writeUInt16((namebytes.length + 5))
                    e.writeByte(1)
                    e.writeInt32(crc)
                    e.write(namebytes)
                elif (tmp == 2):
                    pass
                else:
                    pass
        ebytes = e.getBytes()
        o.writeUInt16(ebytes.length)
        o.writeString(f.fileName)
        o.write(ebytes)
        self.files.add(_hx_AnonObject({'name': f.fileName, 'compressed': f.compressed, 'clen': f.data.length, 'size': f.fileSize, 'crc': f.crc32, 'date': f.fileTime, 'fields': ebytes}))

    def write(self,files):
        _g_head = files.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            f = val
            self.writeEntryHeader(f)
            self.o.writeFullBytes(f.data,0,f.data.length)
        self.writeCDR()

    def writeCDR(self):
        cdr_size = 0
        cdr_offset = 0
        _g_head = self.files.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            f = val
            namelen = len(f.name)
            extraFieldsLength = f.fields.length
            self.o.writeInt32(33639248)
            self.o.writeUInt16(20)
            self.o.writeUInt16(20)
            self.o.writeUInt16(0)
            self.o.writeUInt16((8 if (f.compressed) else 0))
            self.writeZipDate(f.date)
            self.o.writeInt32(f.crc)
            self.o.writeInt32(f.clen)
            self.o.writeInt32(f.size)
            self.o.writeUInt16(namelen)
            self.o.writeUInt16(extraFieldsLength)
            self.o.writeUInt16(0)
            self.o.writeUInt16(0)
            self.o.writeUInt16(0)
            self.o.writeInt32(0)
            self.o.writeInt32(cdr_offset)
            self.o.writeString(f.name)
            self.o.write(f.fields)
            cdr_size = (cdr_size + (((46 + namelen) + extraFieldsLength)))
            cdr_offset = (cdr_offset + ((((30 + namelen) + extraFieldsLength) + f.clen)))
        self.o.writeInt32(101010256)
        self.o.writeUInt16(0)
        self.o.writeUInt16(0)
        self.o.writeUInt16(self.files.length)
        self.o.writeUInt16(self.files.length)
        self.o.writeInt32(cdr_size)
        self.o.writeInt32(cdr_offset)
        self.o.writeUInt16(0)

haxe_zip_Writer._hx_class = haxe_zip_Writer


class hxp_Haxelib:
    _hx_class_name = "hxp.Haxelib"
    __slots__ = ("name", "version")
    _hx_fields = ["name", "version"]
    _hx_methods = ["clone", "versionMatches"]
    _hx_statics = ["debug", "pathOverrides", "workingDirectory", "repositoryPath", "paths", "toolPath", "versions", "findFolderMatch", "findMatch", "getPath", "getPathVersion", "getRepositoryPath", "getVersion", "runCommand", "runProcess", "setOverridePath"]

    def __init__(self,name,version = None):
        if (version is None):
            version = ""
        self.name = name
        self.version = version

    def clone(self):
        haxelib = hxp_Haxelib(self.name,self.version)
        return haxelib

    def versionMatches(self,other):
        if ((self.version == "") or ((self.version is None))):
            return True
        if ((other == "") or ((other is None))):
            return False
        _hx_filter = self.version
        _hx_filter = hxp_StringTools.replace(_hx_filter,".","\\.")
        _hx_filter = hxp_StringTools.replace(_hx_filter,"*",".*")
        regexp = EReg(("^" + ("null" if _hx_filter is None else _hx_filter)),"i")
        regexp.matchObj = python_lib_Re.search(regexp.pattern,other)
        return (regexp.matchObj is not None)
    repositoryPath = None

    @staticmethod
    def findFolderMatch(haxelib,directory):
        versions = list()
        version = None
        try:
            _g = 0
            _g1 = sys_FileSystem.readDirectory(directory)
            while (_g < len(_g1)):
                file = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
                _g = (_g + 1)
                try:
                    version = hxp__Version_Version_Impl_.stringToVersion(hxp_StringTools.replace(file,",","."))
                    versions.append(version)
                except BaseException as _g2:
                    None
        except BaseException as _g:
            None
        return hxp_Haxelib.findMatch(haxelib,versions)

    @staticmethod
    def findMatch(haxelib,otherVersions):
        matches = []
        _g = 0
        while (_g < len(otherVersions)):
            otherVersion = (otherVersions[_g] if _g >= 0 and _g < len(otherVersions) else None)
            _g = (_g + 1)
            if haxelib.versionMatches(hxp__Version_Version_Impl_.toString(otherVersion)):
                matches.append(otherVersion)
        if (len(matches) == 0):
            return None
        bestMatch = None
        _g = 0
        while (_g < len(matches)):
            match = (matches[_g] if _g >= 0 and _g < len(matches) else None)
            _g = (_g + 1)
            if ((bestMatch is None) or hxp__Version_Version_Impl_.greaterThan(match,bestMatch)):
                bestMatch = match
        return bestMatch

    @staticmethod
    def getPath(haxelib,validate = None,clearCache = None):
        if (validate is None):
            validate = False
        if (clearCache is None):
            clearCache = False
        name = haxelib.name
        if (name in hxp_Haxelib.pathOverrides.h):
            if (not (name in hxp_Haxelib.versions.h)):
                this1 = hxp_Haxelib.versions
                value = hxp_Haxelib.getPathVersion(hxp_Haxelib.pathOverrides.h.get(name,None))
                this1.h[name] = value
            return hxp_Haxelib.pathOverrides.h.get(name,None)
        if ((haxelib.version is not None) and ((haxelib.version != ""))):
            name = (("null" if name is None else name) + HxOverrides.stringOrNull(((":" + HxOverrides.stringOrNull(haxelib.version)))))
        if (name in hxp_Haxelib.pathOverrides.h):
            if (not (name in hxp_Haxelib.versions.h)):
                version = hxp_Haxelib.getPathVersion(hxp_Haxelib.pathOverrides.h.get(name,None))
                hxp_Haxelib.versions.h[haxelib.name] = version
                hxp_Haxelib.versions.h[name] = version
            return hxp_Haxelib.pathOverrides.h.get(name,None)
        if clearCache:
            hxp_Haxelib.paths.remove(name)
            hxp_Haxelib.versions.remove(name)
        if (not (name in hxp_Haxelib.paths.h)):
            cache = hxp_Log.verbose
            hxp_Log.verbose = hxp_Haxelib.debug
            output = ""
            try:
                cacheDryRun = hxp_System.dryRun
                hxp_System.dryRun = False
                output = hxp_Haxelib.runProcess(hxp_Haxelib.workingDirectory,["path", name],True,True,True)
                if (output is None):
                    output = ""
                hxp_System.dryRun = cacheDryRun
            except BaseException as _g:
                None
            hxp_Log.verbose = cache
            lines = output.split("\n")
            result = ""
            _g = 1
            _g1 = len(lines)
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                trim = hxp_StringTools.trim((lines[i] if i >= 0 and i < len(lines) else None))
                if ((trim == (("-D " + HxOverrides.stringOrNull(haxelib.name)))) or hxp_StringTools.startsWith(trim,(("-D " + HxOverrides.stringOrNull(haxelib.name)) + "="))):
                    result = hxp_StringTools.trim(python_internal_ArrayImpl._get(lines, (i - 1)))
            if (result == ""):
                try:
                    _g = 0
                    while (_g < len(lines)):
                        line = (lines[_g] if _g >= 0 and _g < len(lines) else None)
                        _g = (_g + 1)
                        if ((line != "") and ((HxString.substr(line,0,1) != "-"))):
                            if sys_FileSystem.exists(line):
                                result = line
                                break
                except BaseException as _g:
                    None
            if validate:
                if (result == ""):
                    startIndex = None
                    if (((output.find("does not have") if ((startIndex is None)) else HxString.indexOfImpl(output,"does not have",startIndex))) > -1):
                        directoryName = ""
                        if (hxp_System.get_hostPlatform() == "windows"):
                            directoryName = "Windows"
                        elif (hxp_System.get_hostPlatform() == "mac"):
                            directoryName = ("Mac64" if ((hxp_System.get_hostArchitecture() == hxp_HostArchitecture.X64)) else "Mac")
                        else:
                            directoryName = ("Linux64" if ((hxp_System.get_hostArchitecture() == hxp_HostArchitecture.X64)) else "Linux")
                        hxp_Log.error((((("haxelib \"" + HxOverrides.stringOrNull(haxelib.name)) + "\" does not have an \"ndll/") + ("null" if directoryName is None else directoryName)) + "\" directory"))
                    else:
                        tmp = None
                        startIndex = None
                        if (((output.find("haxelib install ") if ((startIndex is None)) else HxString.indexOfImpl(output,"haxelib install ",startIndex))) > -1):
                            _hx_str = ("haxelib install " + HxOverrides.stringOrNull(haxelib.name))
                            startIndex = None
                            tmp = (((output.find(_hx_str) if ((startIndex is None)) else HxString.indexOfImpl(output,_hx_str,startIndex))) == -1)
                        else:
                            tmp = False
                        if tmp:
                            startIndex = None
                            start = (((output.find("haxelib install ") if ((startIndex is None)) else HxString.indexOfImpl(output,"haxelib install ",startIndex))) + 16)
                            startIndex = None
                            end = None
                            if (startIndex is None):
                                end = output.rfind("'", 0, len(output))
                            else:
                                i = output.rfind("'", 0, (startIndex + 1))
                                startLeft = (max(0,((startIndex + 1) - len("'"))) if ((i == -1)) else (i + 1))
                                check = output.find("'", startLeft, len(output))
                                end = (check if (((check > i) and ((check <= startIndex)))) else i)
                            dependencyName = HxString.substring(output,start,end)
                            hxp_Log.error((((("Could not find haxelib \"" + ("null" if dependencyName is None else dependencyName)) + "\" (dependency of \"") + HxOverrides.stringOrNull(haxelib.name)) + "\"), does it need to be installed?"))
                        elif (haxelib.version != ""):
                            hxp_Log.error((((("Could not find haxelib \"" + HxOverrides.stringOrNull(haxelib.name)) + "\" version \"") + HxOverrides.stringOrNull(haxelib.version)) + "\", does it need to be installed?"))
                        else:
                            hxp_Log.error((("Could not find haxelib \"" + HxOverrides.stringOrNull(haxelib.name)) + "\", does it need to be installed?"))
            standardizedPath = hxp_Path.standardize(result,False)
            pathSplit = standardizedPath.split("/")
            hasHaxelibJSON = False
            while ((not hasHaxelibJSON) and ((len(pathSplit) > 0))):
                path = "/".join([python_Boot.toString1(x1,'') for x1 in pathSplit])
                jsonPath = hxp_Path.combine(path,"haxelib.json")
                if sys_FileSystem.exists(jsonPath):
                    hxp_Haxelib.paths.h[name] = path
                    if ((haxelib.version != "") and ((haxelib.version is not None))):
                        hxp_Haxelib.paths.h[haxelib.name] = path
                        version = hxp_Haxelib.getPathVersion(path)
                        hxp_Haxelib.versions.h[name] = version
                        hxp_Haxelib.versions.h[haxelib.name] = version
                    else:
                        this1 = hxp_Haxelib.versions
                        value = hxp_Haxelib.getPathVersion(path)
                        this1.h[name] = value
                    hasHaxelibJSON = True
                elif (len(pathSplit) != 0):
                    pathSplit.pop()
            if (not hasHaxelibJSON):
                hxp_Haxelib.paths.h[name] = result
        return hxp_Haxelib.paths.h.get(name,None)

    @staticmethod
    def getPathVersion(path):
        path = hxp_Path.combine(path,"haxelib.json")
        if sys_FileSystem.exists(path):
            try:
                json = python_lib_Json.loads(sys_io_File.getContent(path),**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'object_hook': python_Lib.dictToAnon})))
                versionString = json.version
                version = hxp__Version_Version_Impl_.stringToVersion(versionString)
                return version
            except BaseException as _g:
                None
        return None

    @staticmethod
    def getRepositoryPath(clearCache = None):
        if (clearCache is None):
            clearCache = False
        if ((hxp_Haxelib.repositoryPath is None) or clearCache):
            cache = hxp_Log.verbose
            hxp_Log.verbose = hxp_Haxelib.debug
            output = ""
            try:
                cacheDryRun = hxp_System.dryRun
                hxp_System.dryRun = False
                output = hxp_Haxelib.runProcess(hxp_Haxelib.workingDirectory,["config"],True,True,True)
                if (output is None):
                    output = ""
                hxp_System.dryRun = cacheDryRun
            except BaseException as _g:
                None
            hxp_Log.verbose = cache
            hxp_Haxelib.repositoryPath = hxp_StringTools.trim(output)
        return hxp_Haxelib.repositoryPath

    @staticmethod
    def getVersion(haxelib = None):
        clearCache = False
        if (haxelib is None):
            haxelib = hxp_Haxelib("hxp")
            clearCache = True
        hxp_Haxelib.getPath(haxelib,True,clearCache)
        return hxp_Haxelib.versions.h.get(haxelib.name,None)

    @staticmethod
    def runCommand(path,args,safeExecute = None,ignoreErrors = None,_hx_print = None):
        if (safeExecute is None):
            safeExecute = True
        if (ignoreErrors is None):
            ignoreErrors = False
        if (_hx_print is None):
            _hx_print = False
        if ("haxelib" in hxp_Haxelib.pathOverrides.h):
            script = hxp_Path.combine(hxp_Haxelib.pathOverrides.h.get("haxelib",None),"run.n")
            if (not sys_FileSystem.exists(script)):
                hxp_Log.error(("Cannot find haxelib script: " + ("null" if script is None else script)))
            return hxp_System.runCommand(path,"neko",([script] + args),safeExecute,ignoreErrors,_hx_print)
        else:
            command = "haxelib"
            return hxp_System.runCommand(path,command,args,safeExecute,ignoreErrors,_hx_print)

    @staticmethod
    def runProcess(path,args,waitForOutput = None,safeExecute = None,ignoreErrors = None,_hx_print = None,returnErrorValue = None):
        if (waitForOutput is None):
            waitForOutput = True
        if (safeExecute is None):
            safeExecute = True
        if (ignoreErrors is None):
            ignoreErrors = False
        if (_hx_print is None):
            _hx_print = False
        if (returnErrorValue is None):
            returnErrorValue = False
        if ("haxelib" in hxp_Haxelib.pathOverrides.h):
            script = hxp_Path.combine(hxp_Haxelib.pathOverrides.h.get("haxelib",None),"run.n")
            if (not sys_FileSystem.exists(script)):
                hxp_Log.error(("Cannot find haxelib script: " + ("null" if script is None else script)))
            return hxp_System.runProcess(path,"neko",([script] + args),waitForOutput,safeExecute,ignoreErrors,_hx_print,returnErrorValue)
        else:
            command = "haxelib"
            return hxp_System.runProcess(path,command,args,waitForOutput,safeExecute,ignoreErrors,_hx_print,returnErrorValue)

    @staticmethod
    def setOverridePath(haxelib,path):
        name = haxelib.name
        version = hxp_Haxelib.getPathVersion(path)
        hxp_Haxelib.pathOverrides.h[name] = path
        this1 = hxp_Haxelib.pathOverrides
        key = ("null" if ((version is None)) else hxp__Version_Version_Impl_.toString(version))
        this1.h[((("null" if name is None else name) + ":") + ("null" if key is None else key))] = path
        hxp_Haxelib.versions.h[name] = version
        this1 = hxp_Haxelib.versions
        key = ("null" if ((version is None)) else hxp__Version_Version_Impl_.toString(version))
        this1.h[((("null" if name is None else name) + ":") + ("null" if key is None else key))] = version

hxp_Haxelib._hx_class = hxp_Haxelib

class hxp_HostArchitecture(Enum):
    __slots__ = ()
    _hx_class_name = "hxp.HostArchitecture"
    _hx_constructs = ["ARMV6", "ARMV7", "X86", "X64"]
hxp_HostArchitecture.ARMV6 = hxp_HostArchitecture("ARMV6", 0, ())
hxp_HostArchitecture.ARMV7 = hxp_HostArchitecture("ARMV7", 1, ())
hxp_HostArchitecture.X86 = hxp_HostArchitecture("X86", 2, ())
hxp_HostArchitecture.X64 = hxp_HostArchitecture("X64", 3, ())
hxp_HostArchitecture._hx_class = hxp_HostArchitecture


class hxp_Log:
    _hx_class_name = "hxp.Log"
    __slots__ = ()
    _hx_statics = ["accentColor", "enableColor", "mute", "resetColor", "verbose", "colorCodes", "colorSupported", "sentWarnings", "error", "info", "print", "println", "stripColor", "warn"]
    colorSupported = None

    @staticmethod
    def error(message,verboseMessage = None,e = None):
        if (verboseMessage is None):
            verboseMessage = ""
        if ((message != "") and (not hxp_Log.mute)):
            output = None
            if (hxp_Log.verbose and ((verboseMessage != ""))):
                output = (("\x1B[31;1mError:\x1B[0m\x1B[1m " + ("null" if verboseMessage is None else verboseMessage)) + "\x1B[0m\n")
            else:
                output = (("\x1B[31;1mError:\x1B[0m \x1B[1m" + ("null" if message is None else message)) + "\x1B[0m\n")
            Sys.stderr().write(haxe_io_Bytes.ofString(hxp_Log.stripColor(output)))
        if (hxp_Log.verbose and ((e is not None))):
            raise haxe_Exception.thrown(e)
        Sys.exit(1)

    @staticmethod
    def info(message,verboseMessage = None):
        if (verboseMessage is None):
            verboseMessage = ""
        if (not hxp_Log.mute):
            if (hxp_Log.verbose and ((verboseMessage != ""))):
                hxp_Log.println(verboseMessage)
            elif (message != ""):
                hxp_Log.println(message)

    @staticmethod
    def print(message):
        python_Lib.printString(Std.string(hxp_Log.stripColor(message)))

    @staticmethod
    def println(message):
        _hx_str = Std.string(hxp_Log.stripColor(message))
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))

    @staticmethod
    def stripColor(output):
        if (hxp_Log.colorSupported is None):
            if (hxp_System.get_hostPlatform() != "windows"):
                result = -1
                try:
                    process = sys_io_Process("tput",["colors"])
                    result = process.exitCode()
                    process.close()
                except BaseException as _g:
                    None
                hxp_Log.colorSupported = (result == 0)
            else:
                hxp_Log.colorSupported = False
                if ((Sys.getEnv("TERM") == "xterm") or ((Sys.getEnv("ANSICON") is not None))):
                    hxp_Log.colorSupported = True
        if (hxp_Log.enableColor and hxp_Log.colorSupported):
            return output
        else:
            return hxp_Log.colorCodes.replace(output,"")

    @staticmethod
    def warn(message,verboseMessage = None,allowRepeat = None):
        if (verboseMessage is None):
            verboseMessage = ""
        if (allowRepeat is None):
            allowRepeat = False
        if (not hxp_Log.mute):
            output = ""
            if (hxp_Log.verbose and ((verboseMessage != ""))):
                output = (("\x1B[33;1mWarning:\x1B[0m \x1B[1m" + ("null" if verboseMessage is None else verboseMessage)) + "\x1B[0m")
            elif (message != ""):
                output = (("\x1B[33;1mWarning:\x1B[0m \x1B[1m" + ("null" if message is None else message)) + "\x1B[0m")
            if ((not allowRepeat) and (output in hxp_Log.sentWarnings.h)):
                return
            hxp_Log.sentWarnings.h[output] = True
            hxp_Log.println(output)
hxp_Log._hx_class = hxp_Log


class hxp_Path(haxe_io_Path):
    _hx_class_name = "hxp.Path"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = ["addTrailingSlash", "combine", "directory", "escape", "expand", "extension", "isAbsolute", "isRelative", "join", "normalize", "relocatePath", "relocatePaths", "removeTrailingSlashes", "safeFileName", "standardize", "startsWith", "tryFullPath", "withExtension", "withoutDirectory", "withoutExtension"]
    _hx_interfaces = []
    _hx_super = haxe_io_Path


    def __init__(self,path):
        super().__init__(path)

    @staticmethod
    def addTrailingSlash(path):
        return haxe_io_Path.addTrailingSlash(path)

    @staticmethod
    def combine(firstPath,secondPath):
        if ((firstPath is None) or ((firstPath == ""))):
            return secondPath
        elif ((secondPath is not None) and ((secondPath != ""))):
            if (hxp_System.get_hostPlatform() == "windows"):
                startIndex = None
                if (((secondPath.find(":") if ((startIndex is None)) else HxString.indexOfImpl(secondPath,":",startIndex))) == 1):
                    return secondPath
            elif (HxString.substr(secondPath,0,1) == "/"):
                return secondPath
            firstSlash = ((HxString.substr(firstPath,-1,None) == "/") or ((HxString.substr(firstPath,-1,None) == "\\")))
            secondSlash = ((HxString.substr(secondPath,0,1) == "/") or ((HxString.substr(secondPath,0,1) == "\\")))
            if (firstSlash and secondSlash):
                return (("null" if firstPath is None else firstPath) + HxOverrides.stringOrNull(HxString.substr(secondPath,1,None)))
            elif ((not firstSlash) and (not secondSlash)):
                return ((("null" if firstPath is None else firstPath) + "/") + ("null" if secondPath is None else secondPath))
            else:
                return (("null" if firstPath is None else firstPath) + ("null" if secondPath is None else secondPath))
        else:
            return firstPath

    @staticmethod
    def directory(path):
        return haxe_io_Path.directory(path)

    @staticmethod
    def escape(path):
        if (hxp_System.get_hostPlatform() != "windows"):
            path = hxp_StringTools.replace(path,"\\ "," ")
            path = hxp_StringTools.replace(path," ","\\ ")
            path = hxp_StringTools.replace(path,"\\'","'")
            path = hxp_StringTools.replace(path,"'","\\'")
        else:
            path = hxp_StringTools.replace(path,"^,",",")
            path = hxp_StringTools.replace(path,",","^,")
            path = hxp_StringTools.replace(path,"^ "," ")
            path = hxp_StringTools.replace(path," ","^ ")
        return hxp_Path.expand(path)

    @staticmethod
    def expand(path):
        if (path is None):
            path = ""
        if (hxp_System.get_hostPlatform() != "windows"):
            if hxp_StringTools.startsWith(path,"~/"):
                path = ((HxOverrides.stringOrNull(Sys.getEnv("HOME")) + "/") + HxOverrides.stringOrNull(HxString.substr(path,2,None)))
        return path

    @staticmethod
    def extension(path):
        return haxe_io_Path.extension(path)

    @staticmethod
    def isAbsolute(path):
        if (hxp_StringTools.startsWith(path,"/") or hxp_StringTools.startsWith(path,"\\")):
            return True
        return False

    @staticmethod
    def isRelative(path):
        return (not hxp_Path.isAbsolute(path))

    @staticmethod
    def join(paths):
        result = ""
        _g = 0
        while (_g < len(paths)):
            path = (paths[_g] if _g >= 0 and _g < len(paths) else None)
            _g = (_g + 1)
            result = hxp_Path.combine(result,path)
        return result

    @staticmethod
    def normalize(path):
        return haxe_io_Path.normalize(path)

    @staticmethod
    def relocatePath(path,targetDirectory):
        if (hxp_Path.isAbsolute(path) or ((targetDirectory == ""))):
            return path
        elif hxp_Path.isAbsolute(targetDirectory):
            return hxp_Path.combine(Sys.getCwd(),path)
        else:
            targetDirectory = hxp_StringTools.replace(targetDirectory,"\\","/")
            splitTarget = targetDirectory.split("/")
            directories = 0
            while (len(splitTarget) > 0):
                _g = (None if ((len(splitTarget) == 0)) else splitTarget.pop(0))
                if (_g is None):
                    directories = (directories + 1)
                else:
                    _g1 = _g
                    _hx_local_1 = len(_g1)
                    if (_hx_local_1 == 1):
                        if (_g1 == "."):
                            pass
                        else:
                            directories = (directories + 1)
                    elif (_hx_local_1 == 0):
                        if (_g1 == ""):
                            pass
                        else:
                            directories = (directories + 1)
                    elif (_hx_local_1 == 2):
                        if (_g1 == ".."):
                            directories = (directories - 1)
                        else:
                            directories = (directories + 1)
                    else:
                        directories = (directories + 1)
            adjust = ""
            _g = 0
            _g1 = directories
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                adjust = (("null" if adjust is None else adjust) + "../")
            return (("null" if adjust is None else adjust) + ("null" if path is None else path))

    @staticmethod
    def relocatePaths(paths,targetDirectory):
        relocatedPaths = list(paths)
        _g = 0
        _g1 = len(paths)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            python_internal_ArrayImpl._set(relocatedPaths, i, hxp_Path.relocatePath((paths[i] if i >= 0 and i < len(paths) else None),targetDirectory))
        return relocatedPaths

    @staticmethod
    def removeTrailingSlashes(path):
        return haxe_io_Path.removeTrailingSlashes(path)

    @staticmethod
    def safeFileName(name):
        safeName = hxp_StringTools.replace(name," ","")
        return safeName

    @staticmethod
    def standardize(path,trailingSlash = None):
        if (trailingSlash is None):
            trailingSlash = False
        if (path is None):
            return None
        path = hxp_StringTools.replace(path,"\\","/")
        path = hxp_StringTools.replace(path,"//","/")
        path = hxp_StringTools.replace(path,"//","/")
        if ((not trailingSlash) and hxp_StringTools.endsWith(path,"/")):
            path = HxString.substr(path,0,(len(path) - 1))
        elif (trailingSlash and (not hxp_StringTools.endsWith(path,"/"))):
            path = (("null" if path is None else path) + "/")
        if ((hxp_System.get_hostPlatform() == "windows") and (((("" if ((1 >= len(path))) else path[1])) == ":"))):
            path = ((HxOverrides.stringOrNull(("" if ((0 >= len(path))) else path[0]).upper()) + ":") + HxOverrides.stringOrNull(HxString.substr(path,2,None)))
        return path

    @staticmethod
    def startsWith(path,prefix):
        return hxp_StringTools.startsWith(hxp_Path.normalize(path),hxp_Path.normalize(prefix))

    @staticmethod
    def tryFullPath(path):
        try:
            return sys_FileSystem.fullPath(path)
        except BaseException as _g:
            None
            return hxp_Path.expand(path)

    @staticmethod
    def withExtension(path,ext):
        return haxe_io_Path.withExtension(path,ext)

    @staticmethod
    def withoutDirectory(path):
        return haxe_io_Path.withoutDirectory(path)

    @staticmethod
    def withoutExtension(path):
        return haxe_io_Path.withoutExtension(path)
hxp_Path._hx_class = hxp_Path


class hxp_StringTools(StringTools):
    _hx_class_name = "hxp.StringTools"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = ["seedNumber", "base64Chars", "base64Encoder", "usedFlatNames", "uuidChars", "base64Decode", "base64Encode", "endsWith", "fastCodeAt", "filter", "formatArray", "formatEnum", "formatUppercaseVariable", "generateHashCode", "generateUUID", "getFlatName", "getUniqueID", "hex", "htmlEscape", "htmlUnescape", "isEof", "isSpace", "lpad", "ltrim", "replace", "rpad", "rtrim", "startsWith", "trim", "underline", "urlDecode", "urlEncode"]
    _hx_interfaces = []
    _hx_super = StringTools

    base64Encoder = None

    @staticmethod
    def base64Decode(base64):
        base64 = hxp_StringTools.trim(base64)
        base64 = hxp_StringTools.replace(base64,"=","")
        if (hxp_StringTools.base64Encoder is None):
            hxp_StringTools.base64Encoder = haxe_crypto_BaseCode(haxe_io_Bytes.ofString(hxp_StringTools.base64Chars))
        _hx_bytes = hxp_StringTools.base64Encoder.decodeBytes(haxe_io_Bytes.ofString(base64))
        return _hx_bytes

    @staticmethod
    def base64Encode(_hx_bytes):
        extension = None
        _g = HxOverrides.mod(_hx_bytes.length, 3)
        if (_g == 1):
            extension = "=="
        elif (_g == 2):
            extension = "="
        else:
            extension = ""
        if (hxp_StringTools.base64Encoder is None):
            hxp_StringTools.base64Encoder = haxe_crypto_BaseCode(haxe_io_Bytes.ofString(hxp_StringTools.base64Chars))
        return (HxOverrides.stringOrNull(hxp_StringTools.base64Encoder.encodeBytes(_hx_bytes).toString()) + ("null" if extension is None else extension))

    @staticmethod
    def endsWith(s,end):
        return s.endswith(end)

    @staticmethod
    def fastCodeAt(s,index):
        if (index >= len(s)):
            return -1
        else:
            return ord(s[index])

    @staticmethod
    def filter(text,include = None,exclude = None):
        if (include is None):
            include = ["*"]
        if (exclude is None):
            exclude = []
        _g = 0
        while (_g < len(exclude)):
            _hx_filter = (exclude[_g] if _g >= 0 and _g < len(exclude) else None)
            _g = (_g + 1)
            if (_hx_filter != ""):
                if (_hx_filter == "*"):
                    return False
                startIndex = None
                if (((_hx_filter.find("*") if ((startIndex is None)) else HxString.indexOfImpl(_hx_filter,"*",startIndex))) == ((len(_hx_filter) - 1))):
                    if hxp_StringTools.startsWith(text,HxString.substr(_hx_filter,0,-1)):
                        return False
                    continue
                _hx_filter = hxp_StringTools.replace(_hx_filter,".","\\.")
                _hx_filter = hxp_StringTools.replace(_hx_filter,"*",".*")
                regexp = EReg((("^" + ("null" if _hx_filter is None else _hx_filter)) + "$"),"i")
                regexp.matchObj = python_lib_Re.search(regexp.pattern,text)
                if (regexp.matchObj is not None):
                    return False
        _g = 0
        while (_g < len(include)):
            _hx_filter = (include[_g] if _g >= 0 and _g < len(include) else None)
            _g = (_g + 1)
            if (_hx_filter != ""):
                if (_hx_filter == "*"):
                    return True
                startIndex = None
                if (((_hx_filter.find("*") if ((startIndex is None)) else HxString.indexOfImpl(_hx_filter,"*",startIndex))) == ((len(_hx_filter) - 1))):
                    if hxp_StringTools.startsWith(text,HxString.substr(_hx_filter,0,-1)):
                        return True
                    continue
                _hx_filter = hxp_StringTools.replace(_hx_filter,".","\\.")
                _hx_filter = hxp_StringTools.replace(_hx_filter,"*",".*")
                regexp = EReg(("^" + ("null" if _hx_filter is None else _hx_filter)),"i")
                regexp.matchObj = python_lib_Re.search(regexp.pattern,text)
                if (regexp.matchObj is not None):
                    return True
        return False

    @staticmethod
    def formatArray(array):
        output = "[ "
        _g = 0
        _g1 = len(array)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            output = (("null" if output is None else output) + Std.string((array[i] if i >= 0 and i < len(array) else None)))
            if (i < ((len(array) - 1))):
                output = (("null" if output is None else output) + ", ")
            else:
                output = (("null" if output is None else output) + " ")
        output = (("null" if output is None else output) + "]")
        return output

    @staticmethod
    def formatEnum(value):
        return ((HxOverrides.stringOrNull(Type.getEnumName(Type.getEnum(value))) + ".") + Std.string(value))

    @staticmethod
    def formatUppercaseVariable(name):
        isAlpha = EReg("[A-Z0-9]","i")
        variableName = ""
        lastWasUpperCase = False
        lastWasAlpha = True
        _g = 0
        _g1 = len(name)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            char = ("" if (((i < 0) or ((i >= len(name))))) else name[i])
            isAlpha.matchObj = python_lib_Re.search(isAlpha.pattern,char)
            if (isAlpha.matchObj is None):
                variableName = (("null" if variableName is None else variableName) + "_")
                lastWasUpperCase = False
                lastWasAlpha = False
            else:
                if ((char == char.upper()) and ((i > 0))):
                    if lastWasUpperCase:
                        tmp = None
                        if (i != ((len(name) - 1))):
                            index = (i + 1)
                            index1 = (i + 1)
                            tmp = ((("" if (((index < 0) or ((index >= len(name))))) else name[index])) == ("" if (((index1 < 0) or ((index1 >= len(name))))) else name[index1]).upper())
                        else:
                            tmp = True
                        if tmp:
                            variableName = (("null" if variableName is None else variableName) + ("null" if char is None else char))
                        else:
                            variableName = (("null" if variableName is None else variableName) + HxOverrides.stringOrNull((("_" + ("null" if char is None else char)))))
                    elif lastWasAlpha:
                        variableName = (("null" if variableName is None else variableName) + HxOverrides.stringOrNull((("_" + ("null" if char is None else char)))))
                    else:
                        variableName = (("null" if variableName is None else variableName) + ("null" if char is None else char))
                    lastWasUpperCase = True
                else:
                    variableName = (("null" if variableName is None else variableName) + HxOverrides.stringOrNull(char.upper()))
                    lastWasUpperCase = ((i == 0) and ((char == char.upper())))
                lastWasAlpha = True
        return variableName

    @staticmethod
    def generateHashCode(value):
        hash = 5381
        length = len(value)
        _g = 0
        _g1 = len(value)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            hash = ((((hash << 5)) + hash) + HxString.charCodeAt(value,i))
        return hash

    @staticmethod
    def generateUUID(length,radix = None,seed = None):
        _this = hxp_StringTools.uuidChars
        chars = list(_this)
        if ((radix is None) or ((radix > len(chars)))):
            radix = len(chars)
        elif (radix < 2):
            radix = 2
        if (seed is None):
            seed = Math.floor((python_lib_Random.random() * 2147483647.0))
        uuid = []
        seedValue = Math.floor((Reflect.field(Math,"fabs")(seed) + 0.5))
        _g = 0
        _g1 = length
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            seedValue1 = None
            try:
                seedValue1 = int(HxOverrides.modf((seedValue * 16807.0), 2147483647.0))
            except BaseException as _g2:
                None
                seedValue1 = None
            seedValue = seedValue1
            chars1 = None
            try:
                chars1 = int(((seedValue / 2147483647.0) * radix))
            except BaseException as _g3:
                None
                chars1 = None
            python_internal_ArrayImpl._set(uuid, i, python_internal_ArrayImpl._get(chars, (0 | chars1)))
        return "".join([python_Boot.toString1(x1,'') for x1 in uuid])

    @staticmethod
    def getFlatName(name):
        chars = name.lower()
        flatName = ""
        _g = 0
        _g1 = len(chars)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            code = HxString.charCodeAt(chars,i)
            if (((((i > 0) and ((code >= HxString.charCodeAt("0",0)))) and ((code <= HxString.charCodeAt("9",0)))) or (((code >= HxString.charCodeAt("a",0)) and ((code <= HxString.charCodeAt("z",0)))))) or ((code == HxString.charCodeAt("_",0)))):
                flatName = (("null" if flatName is None else flatName) + HxOverrides.stringOrNull(("" if (((i < 0) or ((i >= len(chars))))) else chars[i])))
            else:
                flatName = (("null" if flatName is None else flatName) + "_")
        if (flatName == ""):
            flatName = "_"
        if (HxString.substr(flatName,0,1) == "_"):
            flatName = ("file" + ("null" if flatName is None else flatName))
        while (flatName in hxp_StringTools.usedFlatNames.h):
            match = EReg("(.*?)(\\d+)","")
            match.matchObj = python_lib_Re.search(match.pattern,flatName)
            if (match.matchObj is not None):
                flatName = (HxOverrides.stringOrNull(match.matchObj.group(1)) + Std.string(((Std.parseInt(match.matchObj.group(2)) + 1))))
            else:
                flatName = (("null" if flatName is None else flatName) + "1")
        hxp_StringTools.usedFlatNames.h[flatName] = "1"
        return flatName

    @staticmethod
    def getUniqueID():
        def _hx_local_3():
            def _hx_local_2():
                _hx_local_0 = hxp_StringTools
                _hx_local_1 = _hx_local_0.seedNumber
                _hx_local_0.seedNumber = (_hx_local_1 + 1)
                return _hx_local_1
            return hxp_StringTools.hex(_hx_local_2(),8)
        return _hx_local_3()

    @staticmethod
    def hex(n,digits = None):
        return StringTools.hex(n,digits)

    @staticmethod
    def htmlEscape(s,quotes = None):
        return StringTools.htmlEscape(s,quotes)

    @staticmethod
    def htmlUnescape(s):
        return StringTools.htmlUnescape(s)

    @staticmethod
    def isEof(c):
        return (c == -1)

    @staticmethod
    def isSpace(s,pos):
        return StringTools.isSpace(s,pos)

    @staticmethod
    def lpad(s,c,l):
        return StringTools.lpad(s,c,l)

    @staticmethod
    def ltrim(s):
        return StringTools.ltrim(s)

    @staticmethod
    def replace(s,sub,by):
        return StringTools.replace(s,sub,by)

    @staticmethod
    def rpad(s,c,l):
        return StringTools.rpad(s,c,l)

    @staticmethod
    def rtrim(s):
        return StringTools.rtrim(s)

    @staticmethod
    def startsWith(s,start):
        return s.startswith(start)

    @staticmethod
    def trim(s):
        return StringTools.trim(s)

    @staticmethod
    def underline(string,character = None):
        if (character is None):
            character = "="
        return ((("null" if string is None else string) + "\n") + HxOverrides.stringOrNull(hxp_StringTools.lpad("",character,len(string))))

    @staticmethod
    def urlDecode(s):
        return python_lib_urllib_Parse.unquote(s)

    @staticmethod
    def urlEncode(s):
        return python_lib_urllib_Parse.quote(s,"")
hxp_StringTools._hx_class = hxp_StringTools


class hxp_System:
    _hx_class_name = "hxp.System"
    __slots__ = ()
    _hx_statics = ["dryRun", "_haxeVersion", "_hostArchitecture", "_hostPlatform", "_isText", "_processorCores", "compress", "_readDirectory", "_readFile", "copyFile", "copyFileTemplate", "copyIfNewer", "findTemplate", "findTemplateRecursive", "deleteFile", "findTemplateRecursive_", "findTemplates", "getLastModified", "getTemporaryDirectory", "getTemporaryFile", "isNewer", "isText", "linkFile", "makeDirectory", "mkdir", "openFile", "openURL", "readBytes", "readDirectory", "readText", "recursiveCopy", "recursiveCopyTemplate", "removeDirectory", "renameFile", "replaceText", "runCommand", "_runCommand", "runProcess", "_runProcess", "runScript", "watch", "writeBytes", "writeText", "get_hostArchitecture", "get_hostPlatform", "get_processorCores"]
    hostArchitecture = None
    hostPlatform = None
    processorCores = None
    _haxeVersion = None
    _hostArchitecture = None
    _hostPlatform = None
    _isText = None

    @staticmethod
    def compress(path,targetPath = None):
        if (targetPath is None):
            targetPath = ""
        if (targetPath == ""):
            targetPath = path
        hxp_System.mkdir(hxp_Path.directory(targetPath))
        if ((hxp_System.get_hostPlatform() == "windows") or (not sys_FileSystem.isDirectory(path))):
            files = haxe_ds_List()
            if sys_FileSystem.isDirectory(path):
                hxp_System._readDirectory(path,"",files)
            else:
                hxp_System._readFile(path,"",files)
            output = sys_io_File.write(targetPath,True)
            hxp_Log.info("",(" - \x1B[1mWriting file:\x1B[0m " + ("null" if targetPath is None else targetPath)))
            writer = haxe_zip_Writer(output)
            writer.write(files)
            output.close()
        else:
            hxp_System.runCommand(path,"zip",["-r", hxp_Path.relocatePath(targetPath,path), "./"])

    @staticmethod
    def _readDirectory(basePath,path,files):
        directory = hxp_Path.combine(basePath,path)
        _g = 0
        _g1 = sys_FileSystem.readDirectory(directory)
        while (_g < len(_g1)):
            file = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            fullPath = hxp_Path.combine(directory,file)
            childPath = hxp_Path.combine(path,file)
            if sys_FileSystem.isDirectory(fullPath):
                hxp_System._readDirectory(basePath,childPath,files)
            else:
                hxp_System._readFile(basePath,childPath,files)

    @staticmethod
    def _readFile(basePath,path,files):
        if (((hxp_Path.extension(path) != "zip") and ((hxp_Path.extension(path) != "crx"))) and ((hxp_Path.extension(path) != "wgt"))):
            fullPath = hxp_Path.combine(basePath,path)
            name = path
            date = Date.now()
            hxp_Log.info("",(" - \x1B[1mCompressing file:\x1B[0m " + ("null" if fullPath is None else fullPath)))
            input = sys_io_File.read(fullPath,True)
            data = input.readAll()
            input.close()
            entry = _hx_AnonObject({'fileName': name, 'fileSize': data.length, 'fileTime': date, 'compressed': False, 'dataSize': data.length, 'data': data, 'crc32': None})
            files.push(entry)

    @staticmethod
    def copyFile(source,destination,context = None,process = None):
        if (process is None):
            process = True
        extension = hxp_Path.extension(source)
        if (process and ((context is not None))):
            if ((extension in hxp_System._isText.h) and (not hxp_System._isText.h.get(extension,None))):
                hxp_System.copyIfNewer(source,destination)
                return
            textFile = False
            if ((extension in hxp_System._isText.h) and hxp_System._isText.h.get(extension,None)):
                textFile = True
            else:
                textFile = hxp_System.isText(source)
            if textFile:
                fileContents = sys_io_File.getContent(source)
                template = haxe_Template(fileContents)
                def _hx_local_0(_,s):
                    return haxe_format_JsonPrinter.print(s,None,None)
                def _hx_local_1(_,s):
                    return HxOverrides.toUpperCase(s)
                def _hx_local_2(_,s,sub,by):
                    return hxp_StringTools.replace(s,sub,by)
                result = template.execute(context,_hx_AnonObject({'toJSON': _hx_local_0, 'upper': _hx_local_1, 'replace': _hx_local_2}))
                try:
                    if sys_FileSystem.exists(destination):
                        existingContent = sys_io_File.getContent(destination)
                        if (result == existingContent):
                            return
                except BaseException as _g:
                    None
                hxp_System.mkdir(hxp_Path.directory(destination))
                hxp_Log.info("",(((" - \x1B[1mCopying template file:\x1B[0m " + ("null" if source is None else source)) + " \x1B[3;37m->\x1B[0m ") + ("null" if destination is None else destination)))
                try:
                    sys_io_File.saveContent(destination,result)
                except BaseException as _g:
                    None
                    hxp_Log.error((("Cannot write to file \"" + ("null" if destination is None else destination)) + "\""))
                return
        hxp_System.copyIfNewer(source,destination)

    @staticmethod
    def copyFileTemplate(templatePaths,source,destination,context = None,process = None,warnIfNotFound = None):
        if (process is None):
            process = True
        if (warnIfNotFound is None):
            warnIfNotFound = True
        path = hxp_System.findTemplate(templatePaths,source,warnIfNotFound)
        if (path is not None):
            hxp_System.copyFile(path,destination,context,process)

    @staticmethod
    def copyIfNewer(source,destination):
        if (not hxp_System.isNewer(source,destination)):
            return
        hxp_System.mkdir(hxp_Path.directory(destination))
        hxp_Log.info("",(((" - \x1B[1mCopying file:\x1B[0m " + ("null" if source is None else source)) + " \x1B[3;37m->\x1B[0m ") + ("null" if destination is None else destination)))
        try:
            sys_io_File.copy(source,destination)
        except BaseException as _g:
            None
            try:
                if sys_FileSystem.exists(destination):
                    hxp_Log.error((("Cannot copy to \"" + ("null" if destination is None else destination)) + "\", is the file in use?"))
                    return
            except BaseException as _g:
                pass
            hxp_Log.error((("Cannot open \"" + ("null" if destination is None else destination)) + "\" for writing, do you have correct access permissions?"))

    @staticmethod
    def findTemplate(templatePaths,path,warnIfNotFound = None):
        if (warnIfNotFound is None):
            warnIfNotFound = True
        matches = hxp_System.findTemplates(templatePaths,path,warnIfNotFound)
        if (len(matches) > 0):
            return python_internal_ArrayImpl._get(matches, (len(matches) - 1))
        return None

    @staticmethod
    def findTemplateRecursive(templatePaths,path,warnIfNotFound = None,destinationPaths = None):
        if (warnIfNotFound is None):
            warnIfNotFound = True
        paths = hxp_System.findTemplates(templatePaths,path,warnIfNotFound)
        if (len(paths) == 0):
            return None
        try:
            if sys_FileSystem.isDirectory((paths[0] if 0 < len(paths) else None)):
                templateFiles = list()
                templateMatched = haxe_ds_StringMap()
                paths.reverse()
                hxp_System.findTemplateRecursive_(paths,"",templateFiles,templateMatched,destinationPaths)
                return templateFiles
        except BaseException as _g:
            None
        _hx_len = (len(paths) - 1)
        pos = 0
        if (pos < 0):
            pos = (len(paths) + pos)
        if (pos < 0):
            pos = 0
        res = paths[pos:(pos + _hx_len)]
        del paths[pos:(pos + _hx_len)]
        if (destinationPaths is not None):
            destinationPaths.append((paths[0] if 0 < len(paths) else None))
        return paths

    @staticmethod
    def deleteFile(path):
        try:
            if (sys_FileSystem.exists(path) and (not sys_FileSystem.isDirectory(path))):
                hxp_Log.info("",(" - \x1B[1mDeleting file:\x1B[0m " + ("null" if path is None else path)))
                sys_FileSystem.deleteFile(path)
        except BaseException as _g:
            None

    @staticmethod
    def findTemplateRecursive_(templatePaths,source,templateFiles,templateMatched,destinationPaths):
        files = None
        _g = 0
        while (_g < len(templatePaths)):
            templatePath = (templatePaths[_g] if _g >= 0 and _g < len(templatePaths) else None)
            _g = (_g + 1)
            try:
                files = sys_FileSystem.readDirectory(hxp_Path.combine(templatePath,source))
                _g1 = 0
                while (_g1 < len(files)):
                    file = (files[_g1] if _g1 >= 0 and _g1 < len(files) else None)
                    _g1 = (_g1 + 1)
                    itemSource = hxp_Path.combine(source,file)
                    if (not (itemSource in templateMatched.h)):
                        templateMatched.h[itemSource] = True
                        path = hxp_Path.combine(templatePath,itemSource)
                        if sys_FileSystem.isDirectory(path):
                            hxp_System.findTemplateRecursive_(templatePaths,itemSource,templateFiles,templateMatched,destinationPaths)
                        else:
                            templateFiles.append(path)
                            if (destinationPaths is not None):
                                destinationPaths.append(itemSource)
            except BaseException as _g2:
                None

    @staticmethod
    def findTemplates(templatePaths,path,warnIfNotFound = None):
        if (warnIfNotFound is None):
            warnIfNotFound = True
        matches = []
        _g = 0
        while (_g < len(templatePaths)):
            templatePath = (templatePaths[_g] if _g >= 0 and _g < len(templatePaths) else None)
            _g = (_g + 1)
            targetPath = hxp_Path.combine(templatePath,path)
            if sys_FileSystem.exists(targetPath):
                matches.append(targetPath)
        if ((len(matches) == 0) and warnIfNotFound):
            hxp_Log.warn(("Could not find template file: " + ("null" if path is None else path)))
        return matches

    @staticmethod
    def getLastModified(source):
        if sys_FileSystem.exists(source):
            return (sys_FileSystem.stat(source).mtime.date.timestamp() * 1000)
        return -1

    @staticmethod
    def getTemporaryDirectory():
        path = hxp_System.getTemporaryFile()
        hxp_System.mkdir(path)
        return path

    @staticmethod
    def getTemporaryFile(extension = None):
        if (extension is None):
            extension = ""
        path = ""
        if (hxp_System.get_hostPlatform() == "windows"):
            path = Sys.getEnv("TEMP")
        else:
            path = Sys.getEnv("TMPDIR")
            if (path is None):
                path = "/tmp"
        path = hxp_Path.combine(path,(("temp_" + Std.string(Math.floor(((16777215 * python_lib_Random.random()) + 0.5)))) + ("null" if extension is None else extension)))
        if sys_FileSystem.exists(path):
            return hxp_System.getTemporaryFile(extension)
        return path

    @staticmethod
    def isNewer(source,destination):
        if ((source is None) or (not sys_FileSystem.exists(source))):
            hxp_Log.error((("Source path \"" + ("null" if source is None else source)) + "\" does not exist"))
            return False
        if sys_FileSystem.exists(destination):
            if ((sys_FileSystem.stat(source).mtime.date.timestamp() * 1000) < ((sys_FileSystem.stat(destination).mtime.date.timestamp() * 1000))):
                return False
        return True

    @staticmethod
    def isText(source):
        if (not sys_FileSystem.exists(source)):
            return False
        input = sys_io_File.read(source,True)
        numChars = 0
        numBytes = 0
        byteHeader = []
        zeroBytes = 0
        try:
            while (numBytes < 512):
                byte = input.readByte()
                if (numBytes < 3):
                    byteHeader.append(byte)
                elif (byteHeader is not None):
                    if (((byteHeader[0] if 0 < len(byteHeader) else None) == 255) and (((byteHeader[1] if 1 < len(byteHeader) else None) == 254))):
                        return True
                    if (((byteHeader[0] if 0 < len(byteHeader) else None) == 254) and (((byteHeader[1] if 1 < len(byteHeader) else None) == 255))):
                        return True
                    if ((((byteHeader[0] if 0 < len(byteHeader) else None) == 239) and (((byteHeader[1] if 1 < len(byteHeader) else None) == 187))) and (((byteHeader[2] if 2 < len(byteHeader) else None) == 191))):
                        return True
                    byteHeader = None
                numBytes = (numBytes + 1)
                if (byte == 0):
                    zeroBytes = (zeroBytes + 1)
                if ((((byte > 8) and ((byte < 16))) or (((byte > 32) and ((byte < 256))))) or ((byte > 287))):
                    numChars = (numChars + 1)
        except BaseException as _g:
            None
        input.close()
        if (((numBytes == 0) or (((numChars / numBytes) > 0.9))) or ((((zeroBytes / numBytes) < 0.015) and (((numChars / numBytes) > 0.5))))):
            return True
        return False

    @staticmethod
    def linkFile(source,destination,symbolic = None,overwrite = None):
        if (symbolic is None):
            symbolic = True
        if (overwrite is None):
            overwrite = False
        if (not hxp_System.isNewer(source,destination)):
            return
        if sys_FileSystem.exists(destination):
            sys_FileSystem.deleteFile(destination)
        if (not sys_FileSystem.exists(destination)):
            try:
                command = "/bin/ln"
                args = []
                if symbolic:
                    args.append("-s")
                if overwrite:
                    args.append("-f")
                args.append(source)
                args.append(destination)
                hxp_System.runCommand(".",command,args)
            except BaseException as _g:
                None

    @staticmethod
    def makeDirectory(directory):
        hxp_System.mkdir(directory)

    @staticmethod
    def mkdir(directory):
        try:
            if (sys_FileSystem.exists(directory) and sys_FileSystem.isDirectory(directory)):
                return
        except BaseException as _g:
            None
        directory = hxp_StringTools.replace(directory,"\\","/")
        total = ""
        if (HxString.substr(directory,0,1) == "/"):
            total = "/"
        parts = directory.split("/")
        oldPath = ""
        tmp = None
        if (len(parts) > 0):
            _this = (parts[0] if 0 < len(parts) else None)
            startIndex = None
            tmp = (((_this.find(":") if ((startIndex is None)) else HxString.indexOfImpl(_this,":",startIndex))) > -1)
        else:
            tmp = False
        if tmp:
            try:
                oldPath = Sys.getCwd()
                Sys.setCwd((HxOverrides.stringOrNull((parts[0] if 0 < len(parts) else None)) + "\\"))
                if (len(parts) != 0):
                    parts.pop(0)
            except BaseException as _g:
                None
                hxp_Log.error((("Cannot create directory \"" + ("null" if directory is None else directory)) + "\""))
        _g = 0
        while (_g < len(parts)):
            part = (parts[_g] if _g >= 0 and _g < len(parts) else None)
            _g = (_g + 1)
            if ((part != ".") and ((part != ""))):
                if ((total != "") and ((total != "/"))):
                    total = (("null" if total is None else total) + "/")
                total = (("null" if total is None else total) + ("null" if part is None else part))
                if (sys_FileSystem.exists(total) and (not sys_FileSystem.isDirectory(total))):
                    hxp_Log.info("",(" - \x1B[1mRemoving file:\x1B[0m " + ("null" if total is None else total)))
                    sys_FileSystem.deleteFile(total)
                if (not sys_FileSystem.exists(total)):
                    hxp_Log.info("",(" - \x1B[1mCreating directory:\x1B[0m " + ("null" if total is None else total)))
                    sys_FileSystem.createDirectory(total)
        if (oldPath != ""):
            Sys.setCwd(oldPath)

    @staticmethod
    def openFile(workingDirectory,targetPath,executable = None):
        if (executable is None):
            executable = ""
        if (executable is None):
            executable = ""
        if (hxp_System.get_hostPlatform() == "windows"):
            args = []
            if (executable == ""):
                executable = "cmd"
                args = ["/c"]
            startIndex = None
            if (((targetPath.find(":\\") if ((startIndex is None)) else HxString.indexOfImpl(targetPath,":\\",startIndex))) == -1):
                hxp_System.runCommand(workingDirectory,executable,(args + [targetPath]))
            else:
                hxp_System.runCommand(workingDirectory,executable,(args + [(".\\" + ("null" if targetPath is None else targetPath))]))
        elif (hxp_System.get_hostPlatform() == "mac"):
            if (executable == ""):
                executable = "/usr/bin/open"
            if (HxString.substr(targetPath,0,1) == "/"):
                hxp_System.runCommand(workingDirectory,executable,["-W", targetPath])
            else:
                hxp_System.runCommand(workingDirectory,executable,["-W", ("./" + ("null" if targetPath is None else targetPath))])
        else:
            if (executable == ""):
                executable = "/usr/bin/xdg-open"
            if (HxString.substr(targetPath,0,1) == "/"):
                hxp_System.runCommand(workingDirectory,executable,[targetPath])
            else:
                hxp_System.runCommand(workingDirectory,executable,[("./" + ("null" if targetPath is None else targetPath))])

    @staticmethod
    def openURL(url):
        if (hxp_System.get_hostPlatform() == "windows"):
            hxp_System.runCommand("","start",[url])
        elif (hxp_System.get_hostPlatform() == "mac"):
            hxp_System.runCommand("","/usr/bin/open",[url])
        else:
            hxp_System.runCommand("","/usr/bin/xdg-open",[url, "&"])

    @staticmethod
    def readBytes(source):
        return sys_io_File.getBytes(source)

    @staticmethod
    def readDirectory(directory,ignore = None,paths = None):
        if sys_FileSystem.exists(directory):
            if (paths is None):
                paths = []
            files = None
            try:
                files = sys_FileSystem.readDirectory(directory)
            except BaseException as _g:
                None
                return paths
            _g = 0
            _g1 = sys_FileSystem.readDirectory(directory)
            while (_g < len(_g1)):
                file = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
                _g = (_g + 1)
                if (ignore is not None):
                    filtered = False
                    _g2 = 0
                    while (_g2 < len(ignore)):
                        _hx_filter = (ignore[_g2] if _g2 >= 0 and _g2 < len(ignore) else None)
                        _g2 = (_g2 + 1)
                        if (_hx_filter == file):
                            filtered = True
                    if filtered:
                        continue
                path = ((("null" if directory is None else directory) + "/") + ("null" if file is None else file))
                try:
                    if sys_FileSystem.isDirectory(path):
                        hxp_System.readDirectory(path,ignore,paths)
                    else:
                        paths.append(path)
                except BaseException as _g3:
                    None
                    return paths
            return paths
        return None

    @staticmethod
    def readText(source):
        return sys_io_File.getContent(source)

    @staticmethod
    def recursiveCopy(source,destination,context = None,process = None):
        if (process is None):
            process = True
        hxp_System.mkdir(destination)
        files = None
        try:
            files = sys_FileSystem.readDirectory(source)
        except BaseException as _g:
            None
            hxp_Log.error((("Could not find source directory \"" + ("null" if source is None else source)) + "\""))
        _g = 0
        while (_g < len(files)):
            file = (files[_g] if _g >= 0 and _g < len(files) else None)
            _g = (_g + 1)
            if (HxString.substr(file,0,1) != "."):
                itemDestination = ((("null" if destination is None else destination) + "/") + ("null" if file is None else file))
                itemSource = ((("null" if source is None else source) + "/") + ("null" if file is None else file))
                if sys_FileSystem.isDirectory(itemSource):
                    hxp_System.recursiveCopy(itemSource,itemDestination,context,process)
                else:
                    hxp_System.copyFile(itemSource,itemDestination,context,process)

    @staticmethod
    def recursiveCopyTemplate(templatePaths = None,source = None,destination = None,context = None,process = None,warnIfNotFound = None):
        if (process is None):
            process = True
        if (warnIfNotFound is None):
            warnIfNotFound = True
        destinations = []
        paths = hxp_System.findTemplateRecursive(templatePaths,source,warnIfNotFound,destinations)
        if (paths is not None):
            hxp_System.mkdir(destination)
            itemDestination = None
            _g = 0
            _g1 = len(paths)
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                itemDestination = hxp_Path.combine(destination,(destinations[i] if i >= 0 and i < len(destinations) else None))
                hxp_System.copyFile((paths[i] if i >= 0 and i < len(paths) else None),itemDestination,context,process)

    @staticmethod
    def removeDirectory(directory):
        if sys_FileSystem.exists(directory):
            files = None
            try:
                files = sys_FileSystem.readDirectory(directory)
            except BaseException as _g:
                None
                return
            _g = 0
            _g1 = sys_FileSystem.readDirectory(directory)
            while (_g < len(_g1)):
                file = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
                _g = (_g + 1)
                path = ((("null" if directory is None else directory) + "/") + ("null" if file is None else file))
                try:
                    if sys_FileSystem.isDirectory(path):
                        hxp_System.removeDirectory(path)
                    else:
                        sys_FileSystem.deleteFile(path)
                except BaseException as _g2:
                    None
            hxp_Log.info("",(" - \x1B[1mRemoving directory:\x1B[0m " + ("null" if directory is None else directory)))
            try:
                sys_FileSystem.deleteDirectory(directory)
            except BaseException as _g:
                None

    @staticmethod
    def renameFile(source,destination):
        hxp_System.mkdir(hxp_Path.directory(destination))
        hxp_Log.info("",(((" - \x1B[1mRenaming file:\x1B[0m " + ("null" if source is None else source)) + " \x1B[3;37m->\x1B[0m ") + ("null" if destination is None else destination)))
        try:
            sys_io_File.copy(source,destination)
        except BaseException as _g:
            None
            try:
                if sys_FileSystem.exists(destination):
                    hxp_Log.error((("Cannot copy to \"" + ("null" if destination is None else destination)) + "\", is the file in use?"))
                    return
            except BaseException as _g:
                pass
        try:
            sys_FileSystem.deleteFile(source)
        except BaseException as _g:
            None

    @staticmethod
    def replaceText(sourcePath,replaceString,replacement):
        if sys_FileSystem.exists(sourcePath):
            output = sys_io_File.getContent(sourcePath)
            startIndex = None
            index = (output.find(replaceString) if ((startIndex is None)) else HxString.indexOfImpl(output,replaceString,startIndex))
            if (index > -1):
                output = ((HxOverrides.stringOrNull(HxString.substr(output,0,index)) + ("null" if replacement is None else replacement)) + HxOverrides.stringOrNull(HxString.substr(output,(index + len(replaceString)),None)))
                sys_io_File.saveContent(sourcePath,output)

    @staticmethod
    def runCommand(path,command,args = None,safeExecute = None,ignoreErrors = None,_hx_print = None):
        if (safeExecute is None):
            safeExecute = True
        if (ignoreErrors is None):
            ignoreErrors = False
        if (_hx_print is None):
            _hx_print = False
        if _hx_print:
            message = command
            if (args is not None):
                _g = 0
                while (_g < len(args)):
                    arg = (args[_g] if _g >= 0 and _g < len(args) else None)
                    _g = (_g + 1)
                    startIndex = None
                    if (((arg.find(" ") if ((startIndex is None)) else HxString.indexOfImpl(arg," ",startIndex))) > -1):
                        message = (("null" if message is None else message) + HxOverrides.stringOrNull((((" \"" + ("null" if arg is None else arg)) + "\""))))
                    else:
                        message = (("null" if message is None else message) + HxOverrides.stringOrNull(((" " + ("null" if arg is None else arg)))))
            _hx_str = Std.string(message)
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        if safeExecute:
            try:
                if ((((path is not None) and ((path != ""))) and (not sys_FileSystem.exists(sys_FileSystem.fullPath(path)))) and (not sys_FileSystem.exists(sys_FileSystem.fullPath(hxp_Path(path).dir)))):
                    hxp_Log.error((("The specified target path \"" + ("null" if path is None else path)) + "\" does not exist"))
                    return 1
                return hxp_System._runCommand(path,command,args)
            except BaseException as _g:
                None
                e = haxe_Exception.caught(_g).unwrap()
                if (not ignoreErrors):
                    hxp_Log.error("",e)
                    return 1
                return 0
        else:
            return hxp_System._runCommand(path,command,args)

    @staticmethod
    def _runCommand(path,command,args):
        oldPath = ""
        if ((path is not None) and ((path != ""))):
            hxp_Log.info("",((" - \x1B[1mChanging directory:\x1B[0m " + ("null" if path is None else path)) + ""))
            if (not hxp_System.dryRun):
                oldPath = Sys.getCwd()
                Sys.setCwd(path)
        argString = ""
        if (args is not None):
            _g = 0
            while (_g < len(args)):
                arg = (args[_g] if _g >= 0 and _g < len(args) else None)
                _g = (_g + 1)
                startIndex = None
                if (((arg.find(" ") if ((startIndex is None)) else HxString.indexOfImpl(arg," ",startIndex))) > -1):
                    argString = (("null" if argString is None else argString) + HxOverrides.stringOrNull((((" \"" + ("null" if arg is None else arg)) + "\""))))
                else:
                    argString = (("null" if argString is None else argString) + HxOverrides.stringOrNull(((" " + ("null" if arg is None else arg)))))
        hxp_Log.info("",((" - \x1B[1mRunning command:\x1B[0m " + ("null" if command is None else command)) + ("null" if argString is None else argString)))
        result = 0
        if (not hxp_System.dryRun):
            if ((args is not None) and ((len(args) > 0))):
                result = Sys.command(command,args)
            else:
                result = Sys.command(command)
            if (oldPath != ""):
                Sys.setCwd(oldPath)
        if (result != 0):
            raise haxe_Exception.thrown(((((("Error running: " + ("null" if command is None else command)) + HxOverrides.stringOrNull((((" " + HxOverrides.stringOrNull(" ".join([python_Boot.toString1(x1,'') for x1 in args]))) if ((args is not None)) else "")))) + " [") + ("null" if path is None else path)) + "]"))
        return result

    @staticmethod
    def runProcess(path,command,args = None,waitForOutput = None,safeExecute = None,ignoreErrors = None,_hx_print = None,returnErrorValue = None):
        if (waitForOutput is None):
            waitForOutput = True
        if (safeExecute is None):
            safeExecute = True
        if (ignoreErrors is None):
            ignoreErrors = False
        if (_hx_print is None):
            _hx_print = False
        if (returnErrorValue is None):
            returnErrorValue = False
        if _hx_print:
            message = command
            if (args is not None):
                _g = 0
                while (_g < len(args)):
                    arg = (args[_g] if _g >= 0 and _g < len(args) else None)
                    _g = (_g + 1)
                    startIndex = None
                    if (((arg.find(" ") if ((startIndex is None)) else HxString.indexOfImpl(arg," ",startIndex))) > -1):
                        message = (("null" if message is None else message) + HxOverrides.stringOrNull((((" \"" + ("null" if arg is None else arg)) + "\""))))
                    else:
                        message = (("null" if message is None else message) + HxOverrides.stringOrNull(((" " + ("null" if arg is None else arg)))))
            _hx_str = Std.string(message)
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        if safeExecute:
            try:
                if ((((path is not None) and ((path != ""))) and (not sys_FileSystem.exists(sys_FileSystem.fullPath(path)))) and (not sys_FileSystem.exists(sys_FileSystem.fullPath(hxp_Path(path).dir)))):
                    hxp_Log.error((("The specified target path \"" + ("null" if path is None else path)) + "\" does not exist"))
                return hxp_System._runProcess(path,command,args,waitForOutput,safeExecute,ignoreErrors,returnErrorValue)
            except BaseException as _g:
                None
                e = haxe_Exception.caught(_g).unwrap()
                if (not ignoreErrors):
                    hxp_Log.error("",e)
                return None
        else:
            return hxp_System._runProcess(path,command,args,waitForOutput,safeExecute,ignoreErrors,returnErrorValue)

    @staticmethod
    def _runProcess(path,command,args,waitForOutput,safeExecute,ignoreErrors,returnErrorValue):
        oldPath = ""
        if ((path is not None) and ((path != ""))):
            hxp_Log.info("",((" - \x1B[1mChanging directory:\x1B[0m " + ("null" if path is None else path)) + ""))
            if (not hxp_System.dryRun):
                oldPath = Sys.getCwd()
                Sys.setCwd(path)
        argString = ""
        if (args is not None):
            _g = 0
            while (_g < len(args)):
                arg = (args[_g] if _g >= 0 and _g < len(args) else None)
                _g = (_g + 1)
                startIndex = None
                if (((arg.find(" ") if ((startIndex is None)) else HxString.indexOfImpl(arg," ",startIndex))) > -1):
                    argString = (("null" if argString is None else argString) + HxOverrides.stringOrNull((((" \"" + ("null" if arg is None else arg)) + "\""))))
                else:
                    argString = (("null" if argString is None else argString) + HxOverrides.stringOrNull(((" " + ("null" if arg is None else arg)))))
        hxp_Log.info("",((" - \x1B[1mRunning process:\x1B[0m " + ("null" if command is None else command)) + ("null" if argString is None else argString)))
        output = ""
        result = 0
        if (not hxp_System.dryRun):
            process = None
            if ((args is not None) and ((len(args) > 0))):
                process = sys_io_Process(command,args)
            else:
                process = sys_io_Process(command)
            if waitForOutput:
                buffer = haxe_io_BytesOutput()
                waiting = True
                while waiting:
                    try:
                        current = process.stdout.readAll(1024)
                        buffer.write(current)
                        if (current.length == 0):
                            waiting = False
                    except BaseException as _g:
                        None
                        if Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof):
                            waiting = False
                        else:
                            raise _g
                result = process.exitCode()
                output = buffer.getBytes().toString()
                if (output == ""):
                    error = process.stderr.readAll().toString()
                    process.close()
                    if ((result != 0) or ((error != ""))):
                        if ignoreErrors:
                            output = error
                        elif (not safeExecute):
                            raise haxe_Exception.thrown(error)
                        else:
                            hxp_Log.error(error)
                        if returnErrorValue:
                            return output
                        else:
                            return None
                else:
                    process.close()
            if (oldPath != ""):
                Sys.setCwd(oldPath)
        return output

    @staticmethod
    def runScript(path,buildArgs,runArgs = None,workingDirectory = None):
        tempDirectory = hxp_System.getTemporaryDirectory()
        hxp_System.mkdir(tempDirectory)
        script = hxp_Path.withoutExtension(hxp_Path.withoutDirectory(path))
        script = (HxOverrides.stringOrNull(HxString.substr(script,0,1).upper()) + HxOverrides.stringOrNull(HxString.substr(script,1,None)))
        scriptFile = hxp_Path.combine(tempDirectory,(("null" if script is None else script) + ".hx"))
        sourcePath = hxp_Path.directory(path)
        args = (["-cp", tempDirectory, "-cp", hxp_Path.tryFullPath(sourcePath)] + buildArgs)
        input = sys_io_File.read(path,False)
        tag = "@:compiler("
        try:
            while True:
                line = input.readLine()
                if hxp_StringTools.startsWith(line,tag):
                    x = HxString.substring(line,(len(tag) + 1),(len(line) - 2))
                    args.append(x)
        except BaseException as _g:
            None
            if (not Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof)):
                raise _g
        input.close()
        hxp_System.copyFile(path,scriptFile)
        args = (args + ["-D", "hxp-interp", "--run"])
        if (runArgs is not None):
            args = (args + runArgs)
        else:
            args.append(script)
        return hxp_System.runCommand(workingDirectory,"haxe",args)

    @staticmethod
    def watch(command,directories):
        suffix = None
        _g = hxp_System.get_hostPlatform()
        if (_g == "linux"):
            suffix = "-linux"
        elif (_g == "mac"):
            suffix = "-mac"
        elif (_g == "windows"):
            suffix = "-windows.exe"
        else:
            return
        if (suffix == "-linux"):
            if (hxp_System.get_hostArchitecture() == hxp_HostArchitecture.X86):
                suffix = (("null" if suffix is None else suffix) + "32")
            else:
                suffix = (("null" if suffix is None else suffix) + "64")
        nodeTemplatePath = [hxp_Path.combine(hxp_Haxelib.getPath(hxp_Haxelib("http-server")),"bin")]
        watchTemplatePath = [hxp_Path.combine(hxp_Haxelib.getPath(hxp_Haxelib("hxp")),"bin")]
        node = hxp_System.findTemplate(nodeTemplatePath,("node" + ("null" if suffix is None else suffix)))
        bin = hxp_System.findTemplate(watchTemplatePath,"node/watch/cli-custom.js")
        if (hxp_System.get_hostPlatform() != "windows"):
            Sys.command("chmod",["+x", node])
        args = [bin, command]
        args = (args + directories)
        args.append("--exit")
        args.append("--ignoreDotFiles")
        args.append("--ignoreUnreadable")
        hxp_System.runCommand("",node,args)

    @staticmethod
    def writeBytes(_hx_bytes,path):
        sys_io_File.saveBytes(path,_hx_bytes)

    @staticmethod
    def writeText(text,path):
        sys_io_File.saveContent(path,text)

    @staticmethod
    def get_hostArchitecture():
        if (hxp_System._hostArchitecture is None):
            _g = hxp_System.get_hostPlatform()
            if ((_g == "mac") or ((_g == "linux"))):
                process = sys_io_Process("uname",["-m"])
                output = process.stdout.readAll().toString()
                error = process.stderr.readAll().toString()
                process.exitCode()
                process.close()
                startIndex = None
                if (((output.find("armv6") if ((startIndex is None)) else HxString.indexOfImpl(output,"armv6",startIndex))) > -1):
                    hxp_System._hostArchitecture = hxp_HostArchitecture.ARMV6
                else:
                    startIndex = None
                    if (((output.find("armv7") if ((startIndex is None)) else HxString.indexOfImpl(output,"armv7",startIndex))) > -1):
                        hxp_System._hostArchitecture = hxp_HostArchitecture.ARMV7
                    else:
                        startIndex = None
                        if (((output.find("64") if ((startIndex is None)) else HxString.indexOfImpl(output,"64",startIndex))) > -1):
                            hxp_System._hostArchitecture = hxp_HostArchitecture.X64
                        else:
                            hxp_System._hostArchitecture = hxp_HostArchitecture.X86
            elif (_g == "windows"):
                architecture = Sys.getEnv("PROCESSOR_ARCHITECTURE")
                wow64Architecture = Sys.getEnv("PROCESSOR_ARCHITEW6432")
                tmp = None
                startIndex = None
                if (((architecture.find("64") if ((startIndex is None)) else HxString.indexOfImpl(architecture,"64",startIndex))) <= -1):
                    if (wow64Architecture is not None):
                        startIndex = None
                        tmp = (((wow64Architecture.find("64") if ((startIndex is None)) else HxString.indexOfImpl(wow64Architecture,"64",startIndex))) > -1)
                    else:
                        tmp = False
                else:
                    tmp = True
                if tmp:
                    hxp_System._hostArchitecture = hxp_HostArchitecture.X64
                else:
                    hxp_System._hostArchitecture = hxp_HostArchitecture.X86
            else:
                hxp_System._hostArchitecture = hxp_HostArchitecture.ARMV6
            hxp_Log.info("",(" - \x1B[1mDetected host architecture:\x1B[0m " + HxOverrides.stringOrNull(Std.string(hxp_System._hostArchitecture).upper())))
        return hxp_System._hostArchitecture

    @staticmethod
    def get_hostPlatform():
        if (hxp_System._hostPlatform is None):
            _this = EReg("window","i")
            s = Sys.systemName()
            _this.matchObj = python_lib_Re.search(_this.pattern,s)
            if (_this.matchObj is not None):
                hxp_System._hostPlatform = "windows"
            else:
                _this = EReg("linux","i")
                s = Sys.systemName()
                _this.matchObj = python_lib_Re.search(_this.pattern,s)
                if (_this.matchObj is not None):
                    hxp_System._hostPlatform = "linux"
                else:
                    _this = EReg("mac","i")
                    s = Sys.systemName()
                    _this.matchObj = python_lib_Re.search(_this.pattern,s)
                    if (_this.matchObj is not None):
                        hxp_System._hostPlatform = "mac"
            hxp_Log.info("",(" - \x1B[1mDetected host platform:\x1B[0m " + HxOverrides.stringOrNull(Std.string(hxp_System._hostPlatform).upper())))
        return hxp_System._hostPlatform

    @staticmethod
    def get_processorCores():
        cacheDryRun = hxp_System.dryRun
        hxp_System.dryRun = False
        if (hxp_System._processorCores < 1):
            result = None
            if (hxp_System.get_hostPlatform() == "windows"):
                env = Sys.getEnv("NUMBER_OF_PROCESSORS")
                if (env is not None):
                    result = env
            elif (hxp_System.get_hostPlatform() == "linux"):
                result = hxp_System.runProcess("","nproc",None,True,True,True)
                if (result is None):
                    cpuinfo = hxp_System.runProcess("","cat",["/proc/cpuinfo"],True,True,True)
                    if (cpuinfo is not None):
                        split = cpuinfo.split("processor")
                        result = Std.string((len(split) - 1))
            elif (hxp_System.get_hostPlatform() == "mac"):
                cores = EReg("Total Number of Cores: (\\d+)","")
                output = hxp_System.runProcess("","/usr/sbin/system_profiler",["-detailLevel", "full", "SPHardwareDataType"])
                cores.matchObj = python_lib_Re.search(cores.pattern,output)
                if (cores.matchObj is not None):
                    result = cores.matchObj.group(1)
            if ((result is None) or ((Std.parseInt(result) < 1))):
                hxp_System._processorCores = 1
            else:
                hxp_System._processorCores = Std.parseInt(result)
        hxp_System.dryRun = cacheDryRun
        return hxp_System._processorCores
hxp_System._hx_class = hxp_System


class hxp__Version_Version_Impl_:
    _hx_class_name = "hxp._Version.Version_Impl_"
    __slots__ = ()
    _hx_statics = ["VERSION", "stringToVersion", "arrayToVersion", "_new", "nextMajor", "nextMinor", "nextPatch", "nextPre", "nextBuild", "withPre", "withBuild", "satisfies", "toString", "equals", "different", "greaterThan", "greaterThanOrEqual", "lessThan", "lessThanOrEqual", "get_major", "get_minor", "get_patch", "get_pre", "get_hasPre", "get_build", "get_hasBuild", "identifiersToString", "parseIdentifiers", "parseIdentifier", "equalsIdentifiers", "greaterThanIdentifiers", "nextIdentifiers", "SANITIZER", "sanitize"]
    major = None
    minor = None
    patch = None
    pre = None
    hasPre = None
    build = None
    hasBuild = None

    @staticmethod
    def stringToVersion(s):
        tmp = None
        if (s is not None):
            _this = hxp__Version_Version_Impl_.VERSION
            _this.matchObj = python_lib_Re.search(_this.pattern,s)
            tmp = (_this.matchObj is None)
        else:
            tmp = True
        if tmp:
            raise haxe_Exception.thrown((("Invalid SemVer format for \"" + ("null" if s is None else s)) + "\""))
        major = Std.parseInt(hxp__Version_Version_Impl_.VERSION.matchObj.group(1))
        minor = Std.parseInt(hxp__Version_Version_Impl_.VERSION.matchObj.group(2))
        patch = Std.parseInt(hxp__Version_Version_Impl_.VERSION.matchObj.group(3))
        pre = hxp__Version_Version_Impl_.parseIdentifiers(hxp__Version_Version_Impl_.VERSION.matchObj.group(4))
        build = hxp__Version_Version_Impl_.parseIdentifiers(hxp__Version_Version_Impl_.VERSION.matchObj.group(5))
        this1 = _hx_AnonObject({'version': [major, minor, patch], 'pre': pre, 'build': build})
        return this1

    @staticmethod
    def arrayToVersion(a):
        def _hx_local_0(v):
            if (v < 0):
                return -v
            else:
                return v
        a = (list(map(_hx_local_0,([] if ((None is a)) else a))) + [0, 0, 0])[0:3]
        this1 = _hx_AnonObject({'version': [(a[0] if 0 < len(a) else None), (a[1] if 1 < len(a) else None), (a[2] if 2 < len(a) else None)], 'pre': [], 'build': []})
        return this1

    @staticmethod
    def _new(major,minor,patch,pre,build):
        this1 = _hx_AnonObject({'version': [major, minor, patch], 'pre': pre, 'build': build})
        return this1

    @staticmethod
    def nextMajor(this1):
        this2 = _hx_AnonObject({'version': [(python_internal_ArrayImpl._get(this1.version, 0) + 1), 0, 0], 'pre': [], 'build': []})
        return this2

    @staticmethod
    def nextMinor(this1):
        this2 = _hx_AnonObject({'version': [python_internal_ArrayImpl._get(this1.version, 0), (python_internal_ArrayImpl._get(this1.version, 1) + 1), 0], 'pre': [], 'build': []})
        return this2

    @staticmethod
    def nextPatch(this1):
        this2 = _hx_AnonObject({'version': [python_internal_ArrayImpl._get(this1.version, 0), python_internal_ArrayImpl._get(this1.version, 1), (python_internal_ArrayImpl._get(this1.version, 2) + 1)], 'pre': [], 'build': []})
        return this2

    @staticmethod
    def nextPre(this1):
        this2 = _hx_AnonObject({'version': [python_internal_ArrayImpl._get(this1.version, 0), python_internal_ArrayImpl._get(this1.version, 1), python_internal_ArrayImpl._get(this1.version, 2)], 'pre': hxp__Version_Version_Impl_.nextIdentifiers(this1.pre), 'build': []})
        return this2

    @staticmethod
    def nextBuild(this1):
        this2 = _hx_AnonObject({'version': [python_internal_ArrayImpl._get(this1.version, 0), python_internal_ArrayImpl._get(this1.version, 1), python_internal_ArrayImpl._get(this1.version, 2)], 'pre': this1.pre, 'build': hxp__Version_Version_Impl_.nextIdentifiers(this1.build)})
        return this2

    @staticmethod
    def withPre(this1,pre,build = None):
        this2 = _hx_AnonObject({'version': [python_internal_ArrayImpl._get(this1.version, 0), python_internal_ArrayImpl._get(this1.version, 1), python_internal_ArrayImpl._get(this1.version, 2)], 'pre': hxp__Version_Version_Impl_.parseIdentifiers(pre), 'build': hxp__Version_Version_Impl_.parseIdentifiers(build)})
        return this2

    @staticmethod
    def withBuild(this1,build):
        this2 = _hx_AnonObject({'version': [python_internal_ArrayImpl._get(this1.version, 0), python_internal_ArrayImpl._get(this1.version, 1), python_internal_ArrayImpl._get(this1.version, 2)], 'pre': this1.pre, 'build': hxp__Version_Version_Impl_.parseIdentifiers(build)})
        return this2

    @staticmethod
    def satisfies(this1,rule):
        return hxp__Version_VersionRule_Impl_.isSatisfiedBy(rule,this1)

    @staticmethod
    def toString(this1):
        if ((this1 is None) or ((this1.version is None))):
            return None
        _this = this1.version
        v = ".".join([python_Boot.toString1(x1,'') for x1 in _this])
        if (len(this1.pre) > 0):
            v = (("null" if v is None else v) + HxOverrides.stringOrNull((("-" + HxOverrides.stringOrNull(hxp__Version_Version_Impl_.identifiersToString(this1.pre))))))
        if (len(this1.build) > 0):
            v = (("null" if v is None else v) + HxOverrides.stringOrNull((("+" + HxOverrides.stringOrNull(hxp__Version_Version_Impl_.identifiersToString(this1.build))))))
        return v

    @staticmethod
    def equals(this1,other):
        if (((python_internal_ArrayImpl._get(this1.version, 0) != python_internal_ArrayImpl._get(other.version, 0)) or ((python_internal_ArrayImpl._get(this1.version, 1) != python_internal_ArrayImpl._get(other.version, 1)))) or ((python_internal_ArrayImpl._get(this1.version, 2) != python_internal_ArrayImpl._get(other.version, 2)))):
            return False
        return hxp__Version_Version_Impl_.equalsIdentifiers(this1.pre,other.pre)

    @staticmethod
    def different(this1,other):
        return (not hxp__Version_Version_Impl_.equals(other,this1))

    @staticmethod
    def greaterThan(this1,other):
        if ((len(this1.pre) > 0) and ((len(other.pre) > 0))):
            if (((python_internal_ArrayImpl._get(this1.version, 0) == python_internal_ArrayImpl._get(other.version, 0)) and ((python_internal_ArrayImpl._get(this1.version, 1) == python_internal_ArrayImpl._get(other.version, 1)))) and ((python_internal_ArrayImpl._get(this1.version, 2) == python_internal_ArrayImpl._get(other.version, 2)))):
                return hxp__Version_Version_Impl_.greaterThanIdentifiers(this1.pre,other.pre)
            else:
                return False
        elif (len(other.pre) > 0):
            if (python_internal_ArrayImpl._get(this1.version, 0) != python_internal_ArrayImpl._get(other.version, 0)):
                return (python_internal_ArrayImpl._get(this1.version, 0) > python_internal_ArrayImpl._get(other.version, 0))
            if (python_internal_ArrayImpl._get(this1.version, 1) != python_internal_ArrayImpl._get(other.version, 1)):
                return (python_internal_ArrayImpl._get(this1.version, 1) > python_internal_ArrayImpl._get(other.version, 1))
            if (python_internal_ArrayImpl._get(this1.version, 2) != python_internal_ArrayImpl._get(other.version, 2)):
                return (python_internal_ArrayImpl._get(this1.version, 2) > python_internal_ArrayImpl._get(other.version, 2))
            if (len(this1.pre) > 0):
                return hxp__Version_Version_Impl_.greaterThanIdentifiers(this1.pre,other.pre)
            else:
                return True
        elif (len(this1.pre) <= 0):
            if (python_internal_ArrayImpl._get(this1.version, 0) != python_internal_ArrayImpl._get(other.version, 0)):
                return (python_internal_ArrayImpl._get(this1.version, 0) > python_internal_ArrayImpl._get(other.version, 0))
            if (python_internal_ArrayImpl._get(this1.version, 1) != python_internal_ArrayImpl._get(other.version, 1)):
                return (python_internal_ArrayImpl._get(this1.version, 1) > python_internal_ArrayImpl._get(other.version, 1))
            if (python_internal_ArrayImpl._get(this1.version, 2) != python_internal_ArrayImpl._get(other.version, 2)):
                return (python_internal_ArrayImpl._get(this1.version, 2) > python_internal_ArrayImpl._get(other.version, 2))
            return hxp__Version_Version_Impl_.greaterThanIdentifiers(this1.pre,other.pre)
        else:
            return False

    @staticmethod
    def greaterThanOrEqual(this1,other):
        if (not hxp__Version_Version_Impl_.equals(this1,other)):
            return hxp__Version_Version_Impl_.greaterThan(this1,other)
        else:
            return True

    @staticmethod
    def lessThan(this1,other):
        return (not hxp__Version_Version_Impl_.greaterThanOrEqual(this1,other))

    @staticmethod
    def lessThanOrEqual(this1,other):
        return (not hxp__Version_Version_Impl_.greaterThan(this1,other))

    @staticmethod
    def get_major(this1):
        return (this1.version[0] if 0 < len(this1.version) else None)

    @staticmethod
    def get_minor(this1):
        return (this1.version[1] if 1 < len(this1.version) else None)

    @staticmethod
    def get_patch(this1):
        return (this1.version[2] if 2 < len(this1.version) else None)

    @staticmethod
    def get_pre(this1):
        return hxp__Version_Version_Impl_.identifiersToString(this1.pre)

    @staticmethod
    def get_hasPre(this1):
        return (len(this1.pre) > 0)

    @staticmethod
    def get_build(this1):
        return hxp__Version_Version_Impl_.identifiersToString(this1.build)

    @staticmethod
    def get_hasBuild(this1):
        return (len(this1.pre) > 0)

    @staticmethod
    def identifiersToString(ids):
        def _hx_local_0(id):
            _this = id.index
            if (_this == 0):
                s = id.params[0]
                return s
            elif (_this == 1):
                i = id.params[0]
                return ("" + Std.string(i))
            else:
                pass
        _this = list(map(_hx_local_0,ids))
        return ".".join([python_Boot.toString1(x1,'') for x1 in _this])

    @staticmethod
    def parseIdentifiers(s):
        _this = ("" if ((None == s)) else s)
        def _hx_local_1():
            def _hx_local_0(s):
                return (s != "")
            return list(map(hxp__Version_Version_Impl_.parseIdentifier,list(filter(_hx_local_0,list(map(hxp__Version_Version_Impl_.sanitize,_this.split(".")))))))
        return _hx_local_1()

    @staticmethod
    def parseIdentifier(s):
        i = Std.parseInt(s)
        if (None == i):
            return hxp_Identifier.StringId(s)
        else:
            return hxp_Identifier.IntId(i)

    @staticmethod
    def equalsIdentifiers(a,b):
        if (len(a) != len(b)):
            return False
        _g = 0
        _g1 = len(a)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            _g2 = (a[i] if i >= 0 and i < len(a) else None)
            _g3 = (b[i] if i >= 0 and i < len(b) else None)
            tmp = _g2.index
            if (tmp == 0):
                if (_g3.index == 0):
                    b1 = _g3.params[0]
                    a1 = _g2.params[0]
                    if (a1 != b1):
                        return False
            elif (tmp == 1):
                if (_g3.index == 1):
                    b2 = _g3.params[0]
                    a2 = _g2.params[0]
                    if (a2 != b2):
                        return False
            else:
                pass
        return True

    @staticmethod
    def greaterThanIdentifiers(a,b):
        _g = 0
        _g1 = len(a)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            _g2 = (a[i] if i >= 0 and i < len(a) else None)
            _g3 = (b[i] if i >= 0 and i < len(b) else None)
            tmp = _g2.index
            if (tmp == 0):
                _g4 = _g2.params[0]
                tmp1 = _g3.index
                if (tmp1 == 0):
                    _g5 = _g3.params[0]
                    b1 = _g5
                    a1 = _g4
                    if (a1 == b1):
                        continue
                    else:
                        b2 = _g5
                        a2 = _g4
                        if (a2 > b2):
                            return True
                        else:
                            return False
                elif (tmp1 == 1):
                    _g6 = _g3.params[0]
                    return True
                else:
                    return False
            elif (tmp == 1):
                _g7 = _g2.params[0]
                if (_g3.index == 1):
                    _g8 = _g3.params[0]
                    b3 = _g8
                    a3 = _g7
                    if (a3 == b3):
                        continue
                    else:
                        b4 = _g8
                        a4 = _g7
                        if (a4 > b4):
                            return True
                        else:
                            return False
                else:
                    return False
            else:
                return False
        return False

    @staticmethod
    def nextIdentifiers(identifiers):
        identifiers1 = list(identifiers)
        i = len(identifiers1)
        while True:
            i = (i - 1)
            tmp = i
            if (not ((tmp >= 0))):
                break
            _g = (identifiers1[i] if i >= 0 and i < len(identifiers1) else None)
            if (_g.index == 1):
                id = _g.params[0]
                python_internal_ArrayImpl._set(identifiers1, i, hxp_Identifier.IntId((id + 1)))
                break
        if (i < 0):
            raise haxe_Exception.thrown(("no numeric identifier found in " + Std.string(identifiers1)))
        return identifiers1

    @staticmethod
    def sanitize(s):
        return hxp__Version_Version_Impl_.SANITIZER.replace(s,"")
hxp__Version_Version_Impl_._hx_class = hxp__Version_Version_Impl_

class hxp_Identifier(Enum):
    __slots__ = ()
    _hx_class_name = "hxp.Identifier"
    _hx_constructs = ["StringId", "IntId"]

    @staticmethod
    def StringId(value):
        return hxp_Identifier("StringId", 0, (value,))

    @staticmethod
    def IntId(value):
        return hxp_Identifier("IntId", 1, (value,))
hxp_Identifier._hx_class = hxp_Identifier


class hxp__Version_VersionRule_Impl_:
    _hx_class_name = "hxp._Version.VersionRule_Impl_"
    __slots__ = ()
    _hx_statics = ["VERSION", "stringToVersionRule", "IS_DIGITS", "versionArray", "versionRuleIsValid", "isSatisfiedBy", "toString"]

    @staticmethod
    def stringToVersionRule(s):
        def _hx_local_1(comp):
            comp = StringTools.trim(comp)
            p = comp.split(" - ")
            if (len(p) == 1):
                comp = StringTools.trim(comp)
                p = EReg("\\s+","").split(comp)
                if (len(p) == 1):
                    if (len(comp) == 0):
                        return hxp_VersionComparator.GreaterThanOrEqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion([0, 0, 0]),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                    else:
                        _this = hxp__Version_VersionRule_Impl_.VERSION
                        _this.matchObj = python_lib_Re.search(_this.pattern,comp)
                        if (_this.matchObj is None):
                            raise haxe_Exception.thrown((("invalid single pattern \"" + ("null" if comp is None else comp)) + "\""))
                        else:
                            v = hxp__Version_VersionRule_Impl_.versionArray(hxp__Version_VersionRule_Impl_.VERSION)
                            vf = (v + [0, 0, 0])[0:3]
                            _g = hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(1)
                            _g1 = len(v)
                            if (_g is None):
                                _g2 = _g1
                                if (_g2 == 0):
                                    return hxp_VersionComparator.GreaterThanOrEqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                elif (_g2 == 1):
                                    version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                    return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMajor(version)))
                                elif (_g2 == 2):
                                    version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                    return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMinor(version)))
                                elif (_g2 == 3):
                                    return hxp_VersionComparator.EqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                else:
                                    p1 = _g
                                    raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                            else:
                                _g2 = _g
                                _hx_local_0 = len(_g2)
                                if (_hx_local_0 == 1):
                                    if (_g2 == "<"):
                                        return hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                    elif (_g2 == ">"):
                                        return hxp_VersionComparator.GreaterThanVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                    elif (_g2 == "^"):
                                        _g2 = _g1
                                        if (_g2 == 1):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMajor(version)))
                                        elif (_g2 == 2):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion((hxp__Version_Version_Impl_.nextMinor(version) if ((python_internal_ArrayImpl._get(version.version, 0) == 0)) else hxp__Version_Version_Impl_.nextMajor(version))))
                                        elif (_g2 == 3):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(((hxp__Version_Version_Impl_.nextPatch(version) if ((python_internal_ArrayImpl._get(version.version, 1) == 0)) else hxp__Version_Version_Impl_.nextMinor(version)) if ((python_internal_ArrayImpl._get(version.version, 0) == 0)) else hxp__Version_Version_Impl_.nextMajor(version))))
                                        else:
                                            p1 = _g
                                            raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                                    elif (_g2 == "="):
                                        _g2 = _g1
                                        if (_g2 == 0):
                                            return hxp_VersionComparator.GreaterThanOrEqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                        elif (_g2 == 1):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMajor(version)))
                                        elif (_g2 == 2):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMinor(version)))
                                        elif (_g2 == 3):
                                            return hxp_VersionComparator.EqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                        else:
                                            p1 = _g
                                            raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                                    elif (_g2 == "v"):
                                        _g2 = _g1
                                        if (_g2 == 0):
                                            return hxp_VersionComparator.GreaterThanOrEqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                        elif (_g2 == 1):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMajor(version)))
                                        elif (_g2 == 2):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMinor(version)))
                                        elif (_g2 == 3):
                                            return hxp_VersionComparator.EqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                        else:
                                            p1 = _g
                                            raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                                    elif (_g2 == "~"):
                                        _g2 = _g1
                                        if (_g2 == 1):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMajor(version)))
                                        elif ((_g2 == 3) or ((_g2 == 2))):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMinor(version)))
                                        else:
                                            p1 = _g
                                            raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                                    else:
                                        p1 = _g
                                        raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                                elif (_hx_local_0 == 0):
                                    if (_g2 == ""):
                                        _g2 = _g1
                                        if (_g2 == 0):
                                            return hxp_VersionComparator.GreaterThanOrEqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                        elif (_g2 == 1):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMajor(version)))
                                        elif (_g2 == 2):
                                            version = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                                            return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(version),hxp_VersionComparator.LessThanVersion(hxp__Version_Version_Impl_.nextMinor(version)))
                                        elif (_g2 == 3):
                                            return hxp_VersionComparator.EqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                        else:
                                            p1 = _g
                                            raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                                    else:
                                        p1 = _g
                                        raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                                elif (_hx_local_0 == 2):
                                    if (_g2 == "<="):
                                        return hxp_VersionComparator.LessThanOrEqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                    elif (_g2 == ">="):
                                        return hxp_VersionComparator.GreaterThanOrEqualVersion(hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(vf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6)))
                                    else:
                                        p1 = _g
                                        raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                                else:
                                    p1 = _g
                                    raise haxe_Exception.thrown(((("invalid prefix \"" + ("null" if p1 is None else p1)) + "\" for rule ") + ("null" if comp is None else comp)))
                elif (len(p) == 2):
                    _this = hxp__Version_VersionRule_Impl_.VERSION
                    _this.matchObj = python_lib_Re.search(_this.pattern,(p[0] if 0 < len(p) else None))
                    if (_this.matchObj is None):
                        raise haxe_Exception.thrown((("left hand parameter is not a valid version rule \"" + HxOverrides.stringOrNull((p[0] if 0 < len(p) else None))) + "\""))
                    lp = hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(1)
                    lva = hxp__Version_VersionRule_Impl_.versionArray(hxp__Version_VersionRule_Impl_.VERSION)
                    lvf = (lva + [0, 0, 0])[0:3]
                    lv = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(lvf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                    if ((lp != ">") and ((lp != ">="))):
                        raise haxe_Exception.thrown((("invalid left parameter version prefix \"" + HxOverrides.stringOrNull((p[0] if 0 < len(p) else None))) + "\", should be either > or >="))
                    _this = hxp__Version_VersionRule_Impl_.VERSION
                    _this.matchObj = python_lib_Re.search(_this.pattern,(p[1] if 1 < len(p) else None))
                    if (_this.matchObj is None):
                        raise haxe_Exception.thrown((("left hand parameter is not a valid version rule \"" + HxOverrides.stringOrNull((p[0] if 0 < len(p) else None))) + "\""))
                    rp = hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(1)
                    rva = hxp__Version_VersionRule_Impl_.versionArray(hxp__Version_VersionRule_Impl_.VERSION)
                    rvf = (rva + [0, 0, 0])[0:3]
                    rv = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion(rvf),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                    if ((rp != "<") and ((rp != "<="))):
                        raise haxe_Exception.thrown((("invalid right parameter version prefix \"" + HxOverrides.stringOrNull((p[1] if 1 < len(p) else None))) + "\", should be either < or <="))
                    return hxp_VersionComparator.AndRule((hxp_VersionComparator.GreaterThanVersion(lv) if ((lp == ">")) else hxp_VersionComparator.GreaterThanOrEqualVersion(lv)),(hxp_VersionComparator.LessThanVersion(rv) if ((rp == "<")) else hxp_VersionComparator.LessThanOrEqualVersion(rv)))
                else:
                    raise haxe_Exception.thrown(("invalid multi pattern " + ("null" if comp is None else comp)))
            elif (len(p) == 2):
                _this = hxp__Version_VersionRule_Impl_.VERSION
                _this.matchObj = python_lib_Re.search(_this.pattern,(p[0] if 0 < len(p) else None))
                if (_this.matchObj is None):
                    raise haxe_Exception.thrown((("left range parameter is not a valid version rule \"" + HxOverrides.stringOrNull((p[0] if 0 < len(p) else None))) + "\""))
                if ((hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(1) is not None) and ((hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(1) != ""))):
                    raise haxe_Exception.thrown((("left range parameter should not be prefixed \"" + HxOverrides.stringOrNull((p[0] if 0 < len(p) else None))) + "\""))
                lv = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion((hxp__Version_VersionRule_Impl_.versionArray(hxp__Version_VersionRule_Impl_.VERSION) + [0, 0, 0])[0:3]),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                _this = hxp__Version_VersionRule_Impl_.VERSION
                _this.matchObj = python_lib_Re.search(_this.pattern,(p[1] if 1 < len(p) else None))
                if (_this.matchObj is None):
                    raise haxe_Exception.thrown((("right range parameter is not a valid version rule \"" + HxOverrides.stringOrNull((p[1] if 1 < len(p) else None))) + "\""))
                if ((hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(1) is not None) and ((hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(1) != ""))):
                    raise haxe_Exception.thrown((("right range parameter should not be prefixed \"" + HxOverrides.stringOrNull((p[1] if 1 < len(p) else None))) + "\""))
                rva = hxp__Version_VersionRule_Impl_.versionArray(hxp__Version_VersionRule_Impl_.VERSION)
                rv = hxp__Version_Version_Impl_.withPre(hxp__Version_Version_Impl_.arrayToVersion((rva + [0, 0, 0])[0:3]),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(5),hxp__Version_VersionRule_Impl_.VERSION.matchObj.group(6))
                if (len(rva) == 1):
                    rv = hxp__Version_Version_Impl_.nextMajor(rv)
                elif (len(rva) == 2):
                    rv = hxp__Version_Version_Impl_.nextMinor(rv)
                return hxp_VersionComparator.AndRule(hxp_VersionComparator.GreaterThanOrEqualVersion(lv),(hxp_VersionComparator.LessThanOrEqualVersion(rv) if ((len(rva) == 3)) else hxp_VersionComparator.LessThanVersion(rv)))
            else:
                raise haxe_Exception.thrown((("invalid pattern \"" + ("null" if comp is None else comp)) + "\""))
        ors = list(map(_hx_local_1,s.split("||")))
        rule = None
        while (len(ors) > 0):
            r = (None if ((len(ors) == 0)) else ors.pop())
            if (None == rule):
                rule = r
            else:
                rule = hxp_VersionComparator.OrRule(r,rule)
        return rule

    @staticmethod
    def versionArray(re):
        arr = []
        t = None
        _g = 2
        while (_g < 5):
            i = _g
            _g = (_g + 1)
            t = re.matchObj.group(i)
            tmp = None
            if (None != t):
                _this = hxp__Version_VersionRule_Impl_.IS_DIGITS
                _this.matchObj = python_lib_Re.search(_this.pattern,t)
                tmp = (_this.matchObj is not None)
            else:
                tmp = False
            if tmp:
                x = Std.parseInt(t)
                arr.append(x)
            else:
                break
        return arr

    @staticmethod
    def versionRuleIsValid(rule):
        try:
            return (hxp__Version_VersionRule_Impl_.stringToVersionRule(rule) is not None)
        except BaseException as _g:
            None
            return False

    @staticmethod
    def isSatisfiedBy(this1,version):
        tmp = this1.index
        if (tmp == 0):
            ver = this1.params[0]
            return hxp__Version_Version_Impl_.equals(version,ver)
        elif (tmp == 1):
            ver = this1.params[0]
            return hxp__Version_Version_Impl_.greaterThan(version,ver)
        elif (tmp == 2):
            ver = this1.params[0]
            return hxp__Version_Version_Impl_.greaterThanOrEqual(version,ver)
        elif (tmp == 3):
            ver = this1.params[0]
            return hxp__Version_Version_Impl_.lessThan(version,ver)
        elif (tmp == 4):
            ver = this1.params[0]
            return hxp__Version_Version_Impl_.lessThanOrEqual(version,ver)
        elif (tmp == 5):
            a = this1.params[0]
            b = this1.params[1]
            if hxp__Version_VersionRule_Impl_.isSatisfiedBy(a,version):
                return hxp__Version_VersionRule_Impl_.isSatisfiedBy(b,version)
            else:
                return False
        elif (tmp == 6):
            a = this1.params[0]
            b = this1.params[1]
            if (not hxp__Version_VersionRule_Impl_.isSatisfiedBy(a,version)):
                return hxp__Version_VersionRule_Impl_.isSatisfiedBy(b,version)
            else:
                return True
        else:
            pass

    @staticmethod
    def toString(this1):
        _g = this1
        tmp = _g.index
        if (tmp == 0):
            ver = _g.params[0]
            return hxp__Version_Version_Impl_.toString(ver)
        elif (tmp == 1):
            ver = _g.params[0]
            return (">" + HxOverrides.stringOrNull((("null" if ((ver is None)) else hxp__Version_Version_Impl_.toString(ver)))))
        elif (tmp == 2):
            ver = _g.params[0]
            return (">=" + HxOverrides.stringOrNull((("null" if ((ver is None)) else hxp__Version_Version_Impl_.toString(ver)))))
        elif (tmp == 3):
            ver = _g.params[0]
            return ("<" + HxOverrides.stringOrNull((("null" if ((ver is None)) else hxp__Version_Version_Impl_.toString(ver)))))
        elif (tmp == 4):
            ver = _g.params[0]
            return ("<=" + HxOverrides.stringOrNull((("null" if ((ver is None)) else hxp__Version_Version_Impl_.toString(ver)))))
        elif (tmp == 5):
            a = _g.params[0]
            b = _g.params[1]
            tmp = a
            tmp1 = b
            return ((HxOverrides.stringOrNull((("null" if ((tmp is None)) else hxp__Version_VersionRule_Impl_.toString(tmp)))) + " ") + HxOverrides.stringOrNull((("null" if ((tmp1 is None)) else hxp__Version_VersionRule_Impl_.toString(tmp1)))))
        elif (tmp == 6):
            a = _g.params[0]
            b = _g.params[1]
            tmp = a
            tmp1 = b
            return ((HxOverrides.stringOrNull((("null" if ((tmp is None)) else hxp__Version_VersionRule_Impl_.toString(tmp)))) + " || ") + HxOverrides.stringOrNull((("null" if ((tmp1 is None)) else hxp__Version_VersionRule_Impl_.toString(tmp1)))))
        else:
            pass
hxp__Version_VersionRule_Impl_._hx_class = hxp__Version_VersionRule_Impl_

class hxp_VersionComparator(Enum):
    __slots__ = ()
    _hx_class_name = "hxp.VersionComparator"
    _hx_constructs = ["EqualVersion", "GreaterThanVersion", "GreaterThanOrEqualVersion", "LessThanVersion", "LessThanOrEqualVersion", "AndRule", "OrRule"]

    @staticmethod
    def EqualVersion(ver):
        return hxp_VersionComparator("EqualVersion", 0, (ver,))

    @staticmethod
    def GreaterThanVersion(ver):
        return hxp_VersionComparator("GreaterThanVersion", 1, (ver,))

    @staticmethod
    def GreaterThanOrEqualVersion(ver):
        return hxp_VersionComparator("GreaterThanOrEqualVersion", 2, (ver,))

    @staticmethod
    def LessThanVersion(ver):
        return hxp_VersionComparator("LessThanVersion", 3, (ver,))

    @staticmethod
    def LessThanOrEqualVersion(ver):
        return hxp_VersionComparator("LessThanOrEqualVersion", 4, (ver,))

    @staticmethod
    def AndRule(a,b):
        return hxp_VersionComparator("AndRule", 5, (a,b))

    @staticmethod
    def OrRule(a,b):
        return hxp_VersionComparator("OrRule", 6, (a,b))
hxp_VersionComparator._hx_class = hxp_VersionComparator


class massive_haxe_Exception:
    _hx_class_name = "massive.haxe.Exception"
    __slots__ = ("type", "message", "info")
    _hx_fields = ["type", "message", "info"]
    _hx_methods = ["toString"]

    def __init__(self,message,info = None):
        self.message = message
        self.info = info
        self.type = massive_haxe_util_ReflectUtil.here(_hx_AnonObject({'fileName': "massive/haxe/Exception.hx", 'lineNumber': 70, 'className': "massive.haxe.Exception", 'methodName': "new"})).className

    def toString(self):
        _hx_str = ((HxOverrides.stringOrNull(self.type) + ": ") + HxOverrides.stringOrNull(self.message))
        if (self.info is not None):
            _hx_str = (("null" if _hx_str is None else _hx_str) + HxOverrides.stringOrNull((((((((" at " + HxOverrides.stringOrNull(self.info.className)) + "#") + HxOverrides.stringOrNull(self.info.methodName)) + " (") + Std.string(self.info.lineNumber)) + ")"))))
        return _hx_str

massive_haxe_Exception._hx_class = massive_haxe_Exception


class massive_haxe_log_ILogClient:
    _hx_class_name = "massive.haxe.log.ILogClient"
    __slots__ = ()
    _hx_methods = ["print"]
massive_haxe_log_ILogClient._hx_class = massive_haxe_log_ILogClient


class massive_haxe_log_LogClient:
    _hx_class_name = "massive.haxe.log.LogClient"
    __slots__ = ()
    _hx_methods = ["print"]
    _hx_interfaces = [massive_haxe_log_ILogClient]

    def __init__(self):
        pass

    def print(self,message,level):
        msg = None
        if (level == massive_haxe_log_LogLevel.console):
            msg = message
        else:
            msg = ((Std.string(level) + ": ") + ("null" if message is None else message))
        _hx_str = Std.string(msg)
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))

massive_haxe_log_LogClient._hx_class = massive_haxe_log_LogClient

class massive_haxe_log_LogLevel(Enum):
    __slots__ = ()
    _hx_class_name = "massive.haxe.log.LogLevel"
    _hx_constructs = ["all", "debug", "info", "warn", "error", "fatal", "console"]
massive_haxe_log_LogLevel.all = massive_haxe_log_LogLevel("all", 0, ())
massive_haxe_log_LogLevel.debug = massive_haxe_log_LogLevel("debug", 1, ())
massive_haxe_log_LogLevel.info = massive_haxe_log_LogLevel("info", 2, ())
massive_haxe_log_LogLevel.warn = massive_haxe_log_LogLevel("warn", 3, ())
massive_haxe_log_LogLevel.error = massive_haxe_log_LogLevel("error", 4, ())
massive_haxe_log_LogLevel.fatal = massive_haxe_log_LogLevel("fatal", 5, ())
massive_haxe_log_LogLevel.console = massive_haxe_log_LogLevel("console", 6, ())
massive_haxe_log_LogLevel._hx_class = massive_haxe_log_LogLevel


class massive_haxe_log_Log:
    _hx_class_name = "massive.haxe.log.Log"
    __slots__ = ()
    _hx_statics = ["logLevel", "logClient", "debug", "info", "warn", "error", "fatal", "console", "log", "convertLogLevelToInt", "convertLogLevelToString", "setLogLevelFromString", "getLogLevelFromString"]

    def __init__(self):
        pass

    @staticmethod
    def debug(message):
        massive_haxe_log_Log.log(message,massive_haxe_log_LogLevel.debug)

    @staticmethod
    def info(message):
        massive_haxe_log_Log.log(message,massive_haxe_log_LogLevel.info)

    @staticmethod
    def warn(message):
        massive_haxe_log_Log.log(message,massive_haxe_log_LogLevel.warn)

    @staticmethod
    def error(message):
        massive_haxe_log_Log.log(message,massive_haxe_log_LogLevel.error)

    @staticmethod
    def fatal(message):
        massive_haxe_log_Log.log(message,massive_haxe_log_LogLevel.fatal)

    @staticmethod
    def console(message):
        massive_haxe_log_Log.log(message,massive_haxe_log_LogLevel.console)

    @staticmethod
    def log(message,level = None):
        if (level is None):
            level = massive_haxe_log_LogLevel.all
        message = Std.string(message)
        i = massive_haxe_log_Log.convertLogLevelToInt(level)
        if ((i >= massive_haxe_log_Log.convertLogLevelToInt(massive_haxe_log_Log.logLevel)) or ((level == massive_haxe_log_LogLevel.console))):
            massive_haxe_log_Log.logClient.print(message,level)

    @staticmethod
    def convertLogLevelToInt(_hx_type):
        tmp = _hx_type.index
        if (tmp == 0):
            return 0
        elif (tmp == 1):
            return 1
        elif (tmp == 2):
            return 2
        elif (tmp == 3):
            return 3
        elif (tmp == 4):
            return 4
        elif (tmp == 5):
            return 5
        elif (tmp == 6):
            return 100
        else:
            pass

    @staticmethod
    def convertLogLevelToString(_hx_type):
        tmp = _hx_type.index
        if (tmp == 0):
            return "all"
        elif (tmp == 1):
            return "debug"
        elif (tmp == 2):
            return "info"
        elif (tmp == 3):
            return "warn"
        elif (tmp == 4):
            return "error"
        elif (tmp == 5):
            return "fatal"
        elif (tmp == 6):
            return ""
        else:
            pass

    @staticmethod
    def setLogLevelFromString(_hx_type):
        massive_haxe_log_Log.logLevel = massive_haxe_log_Log.getLogLevelFromString(_hx_type)

    @staticmethod
    def getLogLevelFromString(_hx_type):
        if (_hx_type == "all"):
            return massive_haxe_log_LogLevel.all
        elif (_hx_type == "debug"):
            return massive_haxe_log_LogLevel.debug
        elif (_hx_type == "info"):
            return massive_haxe_log_LogLevel.info
        elif (_hx_type == "warn"):
            return massive_haxe_log_LogLevel.warn
        elif (_hx_type == "error"):
            return massive_haxe_log_LogLevel.error
        elif (_hx_type == "fatal"):
            return massive_haxe_log_LogLevel.fatal
        else:
            return massive_haxe_log_LogLevel.debug
massive_haxe_log_Log._hx_class = massive_haxe_log_Log


class massive_haxe_util_ReflectUtil:
    _hx_class_name = "massive.haxe.util.ReflectUtil"
    __slots__ = ()
    _hx_statics = ["here"]

    @staticmethod
    def here(info = None):
        return info
massive_haxe_util_ReflectUtil._hx_class = massive_haxe_util_ReflectUtil


class massive_sys_io_File:
    _hx_class_name = "massive.sys.io.File"
    __slots__ = ("exists", "isDirectory", "isFile", "isUnknown", "isNativeDirectory", "nativePath", "fileName", "name", "extension", "parent", "raw", "path", "isEmpty", "type")
    _hx_fields = ["raw", "path", "type"]
    _hx_methods = ["setInternalPath", "toString", "resolvePath", "resolveDirectory", "resolveFile", "getRelativePath", "clone", "createDirectory", "deleteDirectory", "deleteDirectoryContents", "createFile", "deleteFile", "copyTo", "copyInto", "moveTo", "moveInto", "writeString", "readString", "getDirectoryListing", "getRecursiveDirectoryListing", "get_exists", "get_isDirectory", "get_isNativeDirectory", "get_isFile", "get_isUnknown", "get_name", "get_fileName", "get_extension", "get_nativePath", "get_parent", "get_isEmpty", "toDebugString"]
    _hx_statics = ["seperator", "current", "tempCount", "temp", "get_current", "get_seperator", "create", "createTempFile", "createTempDirectory", "deleteTempFiles"]

    def __init__(self,filePath,fileType = None,createImmediately = None):
        if (createImmediately is None):
            createImmediately = False
        self.type = None
        self.isEmpty = None
        self.path = None
        self.raw = None
        self.parent = None
        self.extension = None
        self.name = None
        self.fileName = None
        self.nativePath = None
        self.isNativeDirectory = None
        self.isUnknown = None
        self.isFile = None
        self.isDirectory = None
        self.exists = None
        massive_sys_io_File.seperator = massive_sys_io_File.get_seperator()
        self.setInternalPath(filePath,fileType)
        if createImmediately:
            if self.get_isDirectory():
                self.createDirectory(None,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 234, 'className': "massive.sys.io.File", 'methodName': "new"}))
            elif self.get_isFile():
                self.createFile()

    def setInternalPath(self,filePath,fileType = None):
        filePath = massive_sys_util_PathUtil.cleanUpPath(filePath)
        self.type = fileType
        pathExists = massive_sys_io_FileSys.exists(filePath)
        if pathExists:
            existingType = (massive_sys_io_FileType.DIRECTORY if (massive_sys_io_FileSys.isDirectory(filePath)) else massive_sys_io_FileType.FILE)
            if (self.type is None):
                self.type = existingType
            elif (self.type != existingType):
                raise haxe_Exception.thrown(massive_sys_io_FileException(("Specified type doesn't match file/dir in system: " + Std.string([self.type, existingType])),self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 256, 'className': "massive.sys.io.File", 'methodName': "setInternalPath"})))
        _this = filePath.split("\\")
        _this1 = "/".join([python_Boot.toString1(x1,'') for x1 in _this])
        segments = _this1.split("/")
        lastSegment = python_internal_ArrayImpl._get(segments, (len(segments) - 1))
        startIndex = None
        dot = None
        if (startIndex is None):
            dot = lastSegment.rfind(".", 0, len(lastSegment))
        else:
            i = lastSegment.rfind(".", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("."))) if ((i == -1)) else (i + 1))
            check = lastSegment.find(".", startLeft, len(lastSegment))
            dot = (check if (((check > i) and ((check <= startIndex)))) else i)
        if (self.type is None):
            if (dot == -1):
                self.type = massive_sys_io_FileType.DIRECTORY
            elif (dot > 0):
                self.type = massive_sys_io_FileType.FILE
            else:
                self.type = massive_sys_io_FileType.UNKNOWN
        self.raw = filePath
        tmp = None
        if (self.type == massive_sys_io_FileType.DIRECTORY):
            _this = self.raw
            _hx_str = massive_sys_io_File.get_seperator()
            startIndex = None
            tmp1 = None
            if (startIndex is None):
                tmp1 = _this.rfind(_hx_str, 0, len(_this))
            elif (_hx_str == ""):
                length = len(_this)
                if (startIndex < 0):
                    startIndex = (length + startIndex)
                    if (startIndex < 0):
                        startIndex = 0
                tmp1 = (length if ((startIndex > length)) else startIndex)
            else:
                i = _this.rfind(_hx_str, 0, (startIndex + 1))
                startLeft = (max(0,((startIndex + 1) - len(_hx_str))) if ((i == -1)) else (i + 1))
                check = _this.find(_hx_str, startLeft, len(_this))
                tmp1 = (check if (((check > i) and ((check <= startIndex)))) else i)
            tmp = (tmp1 != ((len(self.raw) - 1)))
        else:
            tmp = False
        if tmp:
            _hx_local_0 = self
            _hx_local_1 = _hx_local_0.raw
            _hx_local_0.raw = (("null" if _hx_local_1 is None else _hx_local_1) + HxOverrides.stringOrNull(massive_sys_io_File.get_seperator()))
            _hx_local_0.raw
        self.path = haxe_io_Path(self.raw)

    def toString(self):
        return self.get_nativePath()

    def resolvePath(self,value,createImmediately = None,fileType = None,posInfos = None):
        if (createImmediately is None):
            createImmediately = False
        if (fileType == massive_sys_io_FileType.DIRECTORY):
            c = HxString.substr(value,-1,None)
            if ((c != "/") and ((c != "\\"))):
                value = (("null" if value is None else value) + "/")
        file = None
        if massive_sys_util_PathUtil.isAbsolutePath(value):
            file = massive_sys_io_File(value,fileType)
        elif (value == "."):
            if self.get_isFile():
                return self.get_parent()
            else:
                return self
        else:
            p = self
            if self.get_isFile():
                p = self.get_parent()
            startIndex = None
            if (((value.find("./") if ((startIndex is None)) else HxString.indexOfImpl(value,"./",startIndex))) == 0):
                value = HxString.substr(value,2,None)
            while True:
                startIndex = None
                if (not ((((value.find("../") if ((startIndex is None)) else HxString.indexOfImpl(value,"../",startIndex))) == 0))):
                    break
                p = p.get_parent()
                if (p is None):
                    raise haxe_Exception.thrown(massive_sys_io_FileException(("Invalid path: " + ("null" if value is None else value)),self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 357, 'className': "massive.sys.io.File", 'methodName': "resolvePath"})))
                value = HxString.substr(value,3,None)
            file = massive_sys_io_File(((HxOverrides.stringOrNull(p.path.dir) + HxOverrides.stringOrNull(massive_sys_io_File.get_seperator())) + ("null" if value is None else value)),fileType)
        if (createImmediately and (not file.get_exists())):
            if file.get_isDirectory():
                file.createDirectory(True,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 368, 'className': "massive.sys.io.File", 'methodName': "resolvePath"}))
            else:
                file.createFile()
        if self.get_isUnknown():
            self.setInternalPath(self.raw,massive_sys_io_FileType.DIRECTORY)
        return file

    def resolveDirectory(self,value,createImmediately = None):
        if (createImmediately is None):
            createImmediately = False
        if (massive_sys_io_File.get_seperator() == "/"):
            _this = value.split("\\")
            value = massive_sys_io_File.get_seperator().join([python_Boot.toString1(x1,'') for x1 in _this])
        else:
            _this = value.split("/")
            value = massive_sys_io_File.get_seperator().join([python_Boot.toString1(x1,'') for x1 in _this])
        _hx_str = massive_sys_io_File.get_seperator()
        startIndex = None
        tmp = None
        if (startIndex is None):
            tmp = value.rfind(_hx_str, 0, len(value))
        elif (_hx_str == ""):
            length = len(value)
            if (startIndex < 0):
                startIndex = (length + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            tmp = (length if ((startIndex > length)) else startIndex)
        else:
            i = value.rfind(_hx_str, 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len(_hx_str))) if ((i == -1)) else (i + 1))
            check = value.find(_hx_str, startLeft, len(value))
            tmp = (check if (((check > i) and ((check <= startIndex)))) else i)
        if (tmp != ((len(value) - 1))):
            value = (("null" if value is None else value) + HxOverrides.stringOrNull(massive_sys_io_File.get_seperator()))
        return self.resolvePath(value,createImmediately,massive_sys_io_FileType.DIRECTORY,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 395, 'className': "massive.sys.io.File", 'methodName': "resolveDirectory"}))

    def resolveFile(self,value,createImmediately = None):
        if (createImmediately is None):
            createImmediately = False
        return self.resolvePath(value,createImmediately,massive_sys_io_FileType.FILE,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 401, 'className': "massive.sys.io.File", 'methodName': "resolveFile"}))

    def getRelativePath(self,ref,useDotDot = None):
        if (useDotDot is None):
            useDotDot = True
        _this = self.path.dir
        delimiter = massive_sys_io_File.get_seperator()
        paths = (list(_this) if ((delimiter == "")) else _this.split(delimiter))
        _this = ref.path.dir
        delimiter = massive_sys_io_File.get_seperator()
        refPaths = (list(_this) if ((delimiter == "")) else _this.split(delimiter))
        path = ""
        pathBefore = ""
        isCommonPath = True
        length = len(paths)
        refLength = len(refPaths)
        i = 0
        x = (length if (python_lib_Math.isnan(length)) else (refLength if (python_lib_Math.isnan(refLength)) else max(length,refLength)))
        l = None
        try:
            l = int(x)
        except BaseException as _g:
            None
            l = None
        _this = self.get_nativePath()
        tmp = ("" if ((0 >= len(_this))) else _this[0])
        _this = ref.get_nativePath()
        if (tmp != (("" if ((0 >= len(_this))) else _this[0]))):
            return ref.get_nativePath()
        if (not self.get_isDirectory()):
            pathBefore = "./"
        while (i < l):
            if (((paths[i] if i >= 0 and i < len(paths) else None) == (refPaths[i] if i >= 0 and i < len(refPaths) else None)) and isCommonPath):
                path = (("null" if path is None else path) + "")
                i = (i + 1)
                continue
            isCommonPath = False
            if (((paths[i] if i >= 0 and i < len(paths) else None) is not None) and (((refPaths[i] if i >= 0 and i < len(refPaths) else None) is not None))):
                if (not useDotDot):
                    return None
                if (path == ""):
                    path = (("null" if path is None else path) + HxOverrides.stringOrNull((refPaths[i] if i >= 0 and i < len(refPaths) else None)))
                else:
                    path = (("null" if path is None else path) + HxOverrides.stringOrNull((("/" + HxOverrides.stringOrNull((refPaths[i] if i >= 0 and i < len(refPaths) else None))))))
                if (pathBefore == "."):
                    pathBefore = (("null" if pathBefore is None else pathBefore) + "/")
                pathBefore = (("null" if pathBefore is None else pathBefore) + "../")
            elif ((paths[i] if i >= 0 and i < len(paths) else None) is None):
                if (path == ""):
                    path = (("null" if path is None else path) + HxOverrides.stringOrNull((refPaths[i] if i >= 0 and i < len(refPaths) else None)))
                else:
                    path = (("null" if path is None else path) + HxOverrides.stringOrNull((("/" + HxOverrides.stringOrNull((refPaths[i] if i >= 0 and i < len(refPaths) else None))))))
            else:
                if (not useDotDot):
                    return None
                pathBefore = (("null" if pathBefore is None else pathBefore) + "../")
            i = (i + 1)
        if (not ref.get_isDirectory()):
            if (path == ""):
                path = (("null" if path is None else path) + HxOverrides.stringOrNull(ref.get_fileName()))
            else:
                path = (("null" if path is None else path) + HxOverrides.stringOrNull((("/" + HxOverrides.stringOrNull(ref.get_fileName())))))
        return (("null" if pathBefore is None else pathBefore) + ("null" if path is None else path))

    def clone(self):
        return massive_sys_io_File(self.get_nativePath())

    def createDirectory(self,force = None,posInfos = None):
        if (force is None):
            force = False
        if self.get_isFile():
            raise haxe_Exception.thrown(massive_sys_io_FileException("Cannot call createDirectory for a file ",self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 524, 'className': "massive.sys.io.File", 'methodName': "createDirectory"})))
        if ((self.get_parent() is not None) and (not self.get_parent().get_exists())):
            self.get_parent().createDirectory(True,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 526, 'className': "massive.sys.io.File", 'methodName': "createDirectory"}))
        if (force and self.get_exists()):
            if self.get_isNativeDirectory():
                self.deleteDirectory(True,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 530, 'className': "massive.sys.io.File", 'methodName': "createDirectory"}))
            else:
                self.deleteFile()
        if ((not self.get_exists()) and ((self.get_isDirectory() or self.get_isUnknown()))):
            try:
                massive_sys_io_FileSys.createDirectory(self.get_nativePath())
            except BaseException as _g:
                None
                e = haxe_Exception.caught(_g).unwrap()
                massive_haxe_log_Log.error(((((("Error creating directory \n" + Std.string(posInfos)) + "\n") + HxOverrides.stringOrNull(self.toDebugString())) + "\n") + Std.string(e)))
                return False
            if self.get_isUnknown():
                self.setInternalPath(self.raw,massive_sys_io_FileType.DIRECTORY)
            return True
        return False

    def deleteDirectory(self,deleteContents = None,posInfos = None):
        if (deleteContents is None):
            deleteContents = True
        if (not self.get_exists()):
            return False
        if (not self.get_isDirectory()):
            raise haxe_Exception.thrown(massive_sys_io_FileException(("cannot deleteDirectory for type: " + Std.string(self.type)),self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 569, 'className': "massive.sys.io.File", 'methodName': "deleteDirectory"})))
        if ((deleteContents == False) and (not self.get_isEmpty())):
            return False
        self.deleteDirectoryContents()
        if (self.get_exists() and massive_sys_io_FileSys.isDirectory(self.get_nativePath())):
            try:
                massive_sys_io_FileSys.deleteDirectory(self.get_nativePath())
            except BaseException as _g:
                None
                e = haxe_Exception.caught(_g).unwrap()
                tmp = (((((("Error deleting directory \n" + Std.string(posInfos)) + "\n") + HxOverrides.stringOrNull(self.toDebugString())) + "\n") + Std.string(e)) + "\n   ")
                _this = massive_sys_io_FileSys.readDirectory(self.get_nativePath())
                massive_haxe_log_Log.error((("null" if tmp is None else tmp) + HxOverrides.stringOrNull("\n   ".join([python_Boot.toString1(x1,'') for x1 in _this]))))
                return False
        return True

    def deleteDirectoryContents(self,_hx_filter = None,exclude = None):
        if (exclude is None):
            exclude = False
        if (not self.get_isDirectory()):
            return False
        if (not self.get_exists()):
            return False
        files = self.getRecursiveDirectoryListing(_hx_filter,exclude)
        _g = 0
        while (_g < len(files)):
            file = (files[_g] if _g >= 0 and _g < len(files) else None)
            _g = (_g + 1)
            if file.get_isDirectory():
                file.deleteDirectory(True,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 611, 'className': "massive.sys.io.File", 'methodName': "deleteDirectoryContents"}))
            else:
                file.deleteFile()
        return True

    def createFile(self,value = None):
        if (value is None):
            value = ""
        if self.get_isDirectory():
            raise haxe_Exception.thrown(massive_sys_io_FileException("Cannot call createFile for a directory object.",self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 627, 'className': "massive.sys.io.File", 'methodName': "createFile"})))
        elif (self.get_isFile() and self.get_exists()):
            raise haxe_Exception.thrown(massive_sys_io_FileException("File already exists",self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 631, 'className': "massive.sys.io.File", 'methodName': "createFile"})))
        if self.get_isUnknown():
            self.setInternalPath(self.raw,massive_sys_io_FileType.FILE)
        self.writeString(value)

    def deleteFile(self):
        try:
            if (self.get_exists() and (not self.get_isNativeDirectory())):
                massive_sys_io_FileSys.deleteFile(self.get_nativePath())
        except BaseException as _g:
            None
            e = haxe_Exception.caught(_g).unwrap()
            raise haxe_Exception.thrown(massive_sys_io_FileException((("Error deleting directory (" + Std.string(e)) + ")"),self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 659, 'className': "massive.sys.io.File", 'methodName': "deleteFile"})))

    def copyTo(self,dst,overwrite = None,_hx_filter = None,exclude = None):
        if (overwrite is None):
            overwrite = True
        if (exclude is None):
            exclude = False
        if (not self.get_exists()):
            raise haxe_Exception.thrown(massive_sys_io_FileException("Cannot copy a file or directory that doesn't exist.",self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 675, 'className': "massive.sys.io.File", 'methodName': "copyTo"})))
        if (self.get_isDirectory() and (not dst.get_isDirectory())):
            raise haxe_Exception.thrown(massive_sys_io_FileException((("Cannot copy a directory to a file (" + Std.string(dst)) + ")"),self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 679, 'className': "massive.sys.io.File", 'methodName': "copyTo"})))
        if (_hx_filter is None):
            _hx_filter = EReg("\\.(svn)|(DS_Store)","")
            exclude = True
        targetDir = None
        targetName = None
        targetFile = None
        if dst.get_isDirectory():
            targetDir = dst
        else:
            targetDir = dst.get_parent()
            targetName = dst.get_fileName()
            targetFile = dst
        if (not targetDir.get_exists()):
            targetDir.createDirectory(None,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 704, 'className': "massive.sys.io.File", 'methodName': "copyTo"}))
        if self.get_isDirectory():
            files = self.getRecursiveDirectoryListing(_hx_filter,exclude,True)
            _g = 0
            while (_g < len(files)):
                file = (files[_g] if _g >= 0 and _g < len(files) else None)
                _g = (_g + 1)
                targetName = self.getRelativePath(file)
                targetFile = (targetDir.resolveDirectory(targetName) if (file.get_isDirectory()) else targetDir.resolveFile(targetName))
                if targetFile.get_isDirectory():
                    if (not targetFile.get_exists()):
                        targetFile.createDirectory(None,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 717, 'className': "massive.sys.io.File", 'methodName': "copyTo"}))
                elif ((not targetFile.get_exists()) or ((overwrite == True))):
                    sys_io_File.copy(file.get_nativePath(),targetFile.get_nativePath())
        else:
            if (targetName is None):
                targetName = self.get_fileName()
            if (targetFile is None):
                targetFile = targetDir.resolvePath(targetName,None,None,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 731, 'className': "massive.sys.io.File", 'methodName': "copyTo"}))
            if ((not targetFile.get_exists()) or ((overwrite == True))):
                sys_io_File.copy(self.get_nativePath(),targetFile.get_nativePath())

    def copyInto(self,dst,overwrite = None,_hx_filter = None,exclude = None):
        if (overwrite is None):
            overwrite = True
        if (exclude is None):
            exclude = False
        if (not dst.get_isDirectory()):
            raise haxe_Exception.thrown(massive_sys_io_FileException((("Cannot copy a directory to a file (" + Std.string(dst)) + ")"),self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 750, 'className': "massive.sys.io.File", 'methodName': "copyInto"})))
        if self.get_isDirectory():
            self.copyTo(dst.resolveDirectory(self.get_name()),overwrite,_hx_filter,exclude)
        else:
            self.copyTo(dst,overwrite,_hx_filter,exclude)

    def moveTo(self,dst,overwrite = None,_hx_filter = None,exclude = None):
        if (overwrite is None):
            overwrite = True
        if (exclude is None):
            exclude = False
        self.copyTo(dst,overwrite,_hx_filter,exclude)
        if self.get_isDirectory():
            self.deleteDirectory(True,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 774, 'className': "massive.sys.io.File", 'methodName': "moveTo"}))
        else:
            self.deleteFile()

    def moveInto(self,dst,overwrite = None,_hx_filter = None,exclude = None):
        if (overwrite is None):
            overwrite = True
        if (exclude is None):
            exclude = False
        if (not dst.get_isDirectory()):
            raise haxe_Exception.thrown(massive_sys_io_FileException((("Cannot move a directory to a file (" + Std.string(dst)) + ")"),self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 792, 'className': "massive.sys.io.File", 'methodName': "moveInto"})))
        if self.get_isDirectory():
            self.moveTo(dst.resolveDirectory(self.get_name()),overwrite,_hx_filter,exclude)
        else:
            self.moveTo(dst,overwrite,_hx_filter,exclude)

    def writeString(self,value,binary = None):
        if (binary is None):
            binary = True
        if self.get_isDirectory():
            raise haxe_Exception.thrown(massive_sys_io_FileException("Cannot write string to a file object.",self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 815, 'className': "massive.sys.io.File", 'methodName': "writeString"})))
        if (not self.get_parent().get_exists()):
            self.get_parent().createDirectory(True,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 818, 'className': "massive.sys.io.File", 'methodName': "writeString"}))
        if self.get_isUnknown():
            self.setInternalPath(self.raw,massive_sys_io_FileType.FILE)
        out = sys_io_File.write(self.get_nativePath(),binary)
        out.writeString(Std.string(value))
        out.flush()
        out.close()

    def readString(self):
        if ((not self.get_exists()) and self.get_isFile()):
            return None
        if ((not self.get_exists()) or (not self.get_isFile())):
            raise haxe_Exception.thrown(massive_sys_io_FileException("File isn't of type file. Cannot load string content.",self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 845, 'className': "massive.sys.io.File", 'methodName': "readString"})))
        try:
            return sys_io_File.getContent(self.get_nativePath())
        except BaseException as _g:
            None
            e = haxe_Exception.caught(_g).unwrap()
            raise haxe_Exception.thrown(massive_sys_io_FileException((("Unknown error (" + Std.string(e)) + ")"),self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 855, 'className': "massive.sys.io.File", 'methodName': "readString"})))

    def getDirectoryListing(self,_hx_filter = None,exclude = None):
        if (exclude is None):
            exclude = False
        if (not self.get_isDirectory()):
            raise haxe_Exception.thrown(massive_sys_io_FileException("Cannot get directory listing for a file object.",self,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 869, 'className': "massive.sys.io.File", 'methodName': "getDirectoryListing"})))
        if (not self.get_exists()):
            return []
        paths = massive_sys_io_FileSys.readDirectory(self.get_nativePath())
        files = []
        if (_hx_filter is None):
            _hx_filter = EReg(".","")
        include = None
        _g = 0
        while (_g < len(paths)):
            p = (paths[_g] if _g >= 0 and _g < len(paths) else None)
            _g = (_g + 1)
            _hx_filter.matchObj = python_lib_Re.search(_hx_filter.pattern,p)
            include = (_hx_filter.matchObj is not None)
            if exclude:
                include = (not include)
            if include:
                x = self.resolvePath(p,None,None,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 889, 'className': "massive.sys.io.File", 'methodName': "getDirectoryListing"}))
                files.append(x)
        return files

    def getRecursiveDirectoryListing(self,_hx_filter = None,exclude = None,orderDirectoriesBeforeFiles = None,rootDir = None):
        if (exclude is None):
            exclude = False
        if (orderDirectoriesBeforeFiles is None):
            orderDirectoriesBeforeFiles = False
        files = []
        localFiles = self.getDirectoryListing()
        includeInFiles = None
        if (_hx_filter is None):
            _hx_filter = EReg(".","")
        if (rootDir is None):
            rootDir = self
        _g = 0
        while (_g < len(localFiles)):
            file = (localFiles[_g] if _g >= 0 and _g < len(localFiles) else None)
            _g = (_g + 1)
            s = rootDir.getRelativePath(file)
            _hx_filter.matchObj = python_lib_Re.search(_hx_filter.pattern,s)
            includeInFiles = (_hx_filter.matchObj is not None)
            if exclude:
                includeInFiles = (not includeInFiles)
            if file.get_isDirectory():
                if (orderDirectoriesBeforeFiles and includeInFiles):
                    files.append(file)
                files = (files + file.getRecursiveDirectoryListing(_hx_filter,exclude,orderDirectoriesBeforeFiles,rootDir))
                if ((not orderDirectoriesBeforeFiles) and includeInFiles):
                    files.append(file)
            elif includeInFiles:
                files.append(file)
        return files

    def get_exists(self):
        if (massive_sys_io_FileSys.get_isWindows() and self.get_isDirectory()):
            return massive_sys_io_FileSys.exists(HxString.substr(self.get_nativePath(),0,-1))
        return massive_sys_io_FileSys.exists(self.get_nativePath())

    def get_isDirectory(self):
        return (self.type == massive_sys_io_FileType.DIRECTORY)

    def get_isNativeDirectory(self):
        if self.get_exists():
            return massive_sys_io_FileSys.isDirectory(self.get_nativePath())
        return False

    def get_isFile(self):
        return (self.type == massive_sys_io_FileType.FILE)

    def get_isUnknown(self):
        return (self.type == massive_sys_io_FileType.UNKNOWN)

    def get_name(self):
        tmp = self.type.index
        if (tmp == 0):
            _this = self.path.dir
            delimiter = massive_sys_io_File.get_seperator()
            _this1 = (list(_this) if ((delimiter == "")) else _this.split(delimiter))
            return (None if ((len(_this1) == 0)) else _this1.pop())
        elif (tmp == 1):
            return self.path.file
        elif (tmp == 2):
            _this = self.path.toString()
            delimiter = massive_sys_io_File.get_seperator()
            _this1 = (list(_this) if ((delimiter == "")) else _this.split(delimiter))
            return (None if ((len(_this1) == 0)) else _this1.pop())
        else:
            pass

    def get_fileName(self):
        r = None
        r1 = self.type.index
        if (r1 == 0):
            r = None
        elif (r1 == 1):
            r = (HxOverrides.stringOrNull(self.get_name()) + HxOverrides.stringOrNull(((("." + HxOverrides.stringOrNull(self.get_extension())) if ((self.get_extension() is not None)) else ""))))
        elif (r1 == 2):
            r = self.get_name()
        else:
            pass
        return r

    def get_extension(self):
        if (self.type.index == 1):
            return self.path.ext
        else:
            return None

    def get_nativePath(self):
        p = self.path.toString()
        return p

    def get_parent(self):
        if self.get_isDirectory():
            _this = self.path.dir
            delimiter = massive_sys_io_File.get_seperator()
            a = (list(_this) if ((delimiter == "")) else _this.split(delimiter))
            if (len(a) != 0):
                a.pop()
            if (len(a) > 0):
                return massive_sys_io_File(massive_sys_io_File.get_seperator().join([python_Boot.toString1(x1,'') for x1 in a]))
        else:
            return massive_sys_io_File(self.path.dir)
        return None

    def get_isEmpty(self):
        if (not self.get_exists()):
            return False
        if (not self.get_isDirectory()):
            return True
        paths = massive_sys_io_FileSys.readDirectory(self.get_nativePath())
        if ((paths is None) or ((len(paths) == 0))):
            return True
        return False

    def toDebugString(self):
        s = ""
        s = (("null" if s is None else s) + HxOverrides.stringOrNull((("\n   " + HxOverrides.stringOrNull(self.toString())))))
        s = (("null" if s is None else s) + HxOverrides.stringOrNull((("\n   fileName: " + HxOverrides.stringOrNull(self.get_fileName())))))
        s = (("null" if s is None else s) + (("\n   exists: " + Std.string(self.get_exists()))))
        s = (("null" if s is None else s) + (("\n   type: " + Std.string(self.type))))
        return s
    seperator = None
    current = None

    @staticmethod
    def get_current():
        return massive_sys_io_File(massive_sys_io_FileSys.getCwd())

    @staticmethod
    def get_seperator():
        if (massive_sys_io_File.seperator is None):
            massive_sys_io_File.seperator = ("\\" if (massive_sys_io_FileSys.get_isWindows()) else "/")
        return massive_sys_io_File.seperator

    @staticmethod
    def create(path,file = None,createImmediately = None,posInfos = None):
        if (createImmediately is None):
            createImmediately = False
        tmp = None
        tmp1 = None
        if massive_sys_io_FileSys.get_isWindows():
            startIndex = None
            tmp1 = (((path.find(":") if ((startIndex is None)) else HxString.indexOfImpl(path,":",startIndex))) == 1)
        else:
            tmp1 = False
        if tmp1:
            startIndex = None
            tmp1 = None
            if (startIndex is None):
                tmp1 = path.rfind("/", 0, len(path))
            else:
                i = path.rfind("/", 0, (startIndex + 1))
                startLeft = (max(0,((startIndex + 1) - len("/"))) if ((i == -1)) else (i + 1))
                check = path.find("/", startLeft, len(path))
                tmp1 = (check if (((check > i) and ((check <= startIndex)))) else i)
            tmp = (tmp1 == ((len(path) - 1)))
        else:
            tmp = False
        if tmp:
            path = (HxOverrides.stringOrNull(HxString.substr(path,0,-1)) + "\\")
        if massive_sys_util_PathUtil.isAbsolutePath(path):
            return massive_sys_io_File(path,None,createImmediately)
        elif (file is not None):
            try:
                return file.resolvePath(path,createImmediately,None,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 87, 'className': "massive.sys.io.File", 'methodName': "create"}))
            except BaseException as _g:
                None
                e = haxe_Exception.caught(_g).unwrap()
                raise haxe_Exception.thrown(massive_sys_io_FileException(((((("Unable to resolve path ( " + ("null" if path is None else path)) + " ) aginst file ( ") + HxOverrides.stringOrNull(file.get_nativePath())) + " ) ") + Std.string(e)),None,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 91, 'className': "massive.sys.io.File", 'methodName': "create"})))
        elif (path == "."):
            return massive_sys_io_File.get_current()
        else:
            raise haxe_Exception.thrown(massive_sys_io_FileException(("Path isn't absolute and no reference file provided: " + ("null" if path is None else path)),None,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 101, 'className': "massive.sys.io.File", 'methodName': "create"})))

    @staticmethod
    def createTempFile(content = None,extension = None):
        if (content is None):
            content = ""
        if (extension is None):
            extension = ".tmp"
        def _hx_local_2():
            _hx_local_0 = massive_sys_io_File
            _hx_local_1 = _hx_local_0.tempCount
            _hx_local_0.tempCount = (_hx_local_1 + 1)
            return _hx_local_1
        name = Std.string(_hx_local_2())
        name1 = ((".tmp_" + ("null" if name is None else name)) + ("null" if extension is None else extension))
        file = massive_sys_io_File.get_current().resolvePath(name1,None,None,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 114, 'className': "massive.sys.io.File", 'methodName': "createTempFile"}))
        file.writeString(content)
        massive_sys_io_File.temp.h[name1] = file
        return file

    @staticmethod
    def createTempDirectory():
        def _hx_local_2():
            _hx_local_0 = massive_sys_io_File
            _hx_local_1 = _hx_local_0.tempCount
            _hx_local_0.tempCount = (_hx_local_1 + 1)
            return _hx_local_1
        name = Std.string(_hx_local_2())
        name1 = (("tmp_" + ("null" if name is None else name)) + HxOverrides.stringOrNull(massive_sys_io_File.get_seperator()))
        file = massive_sys_io_File.get_current().resolveDirectory(name1)
        file.createDirectory(True,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 131, 'className': "massive.sys.io.File", 'methodName': "createTempDirectory"}))
        massive_sys_io_File.temp.h[name1] = file
        return file

    @staticmethod
    def deleteTempFiles():
        file = None
        key = massive_sys_io_File.temp.keys()
        while key.hasNext():
            key1 = key.next()
            if (key1 in massive_sys_io_File.temp.h):
                file = massive_sys_io_File.temp.h.get(key1,None)
                if file.get_isDirectory():
                    file.deleteDirectory(True,_hx_AnonObject({'fileName': "massive/sys/io/File.hx", 'lineNumber': 154, 'className': "massive.sys.io.File", 'methodName': "deleteTempFiles"}))
                else:
                    file.deleteFile()
        massive_sys_io_File.temp = haxe_ds_StringMap()

massive_sys_io_File._hx_class = massive_sys_io_File

class massive_sys_io_FileType(Enum):
    __slots__ = ()
    _hx_class_name = "massive.sys.io.FileType"
    _hx_constructs = ["DIRECTORY", "FILE", "UNKNOWN"]
massive_sys_io_FileType.DIRECTORY = massive_sys_io_FileType("DIRECTORY", 0, ())
massive_sys_io_FileType.FILE = massive_sys_io_FileType("FILE", 1, ())
massive_sys_io_FileType.UNKNOWN = massive_sys_io_FileType("UNKNOWN", 2, ())
massive_sys_io_FileType._hx_class = massive_sys_io_FileType


class massive_sys_io_FileException(massive_haxe_Exception):
    _hx_class_name = "massive.sys.io.FileException"
    __slots__ = ("file",)
    _hx_fields = ["file"]
    _hx_methods = ["toString"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = massive_haxe_Exception


    def __init__(self,message,file = None,posInfos = None):
        self.file = file
        super().__init__(message,posInfos)

    def toString(self):
        _hx_str = super().toString()
        if (self.file is not None):
            _hx_str = (("null" if _hx_str is None else _hx_str) + HxOverrides.stringOrNull(((("[File=" + HxOverrides.stringOrNull(self.file.get_nativePath())) + "]"))))
        return _hx_str

massive_sys_io_FileException._hx_class = massive_sys_io_FileException


class massive_sys_io_FileSys:
    _hx_class_name = "massive.sys.io.FileSys"
    __slots__ = ()
    _hx_statics = ["_isWindows", "isWindows", "_isMac", "isMac", "_isLinux", "isLinux", "get_isWindows", "get_isMac", "get_isLinux", "safePath", "getCwd", "setCwd", "exists", "isDirectory", "readDirectory", "createDirectory", "deleteDirectory", "deleteFile"]

    def __init__(self):
        pass
    _isWindows = None
    isWindows = None
    _isMac = None
    isMac = None
    _isLinux = None
    isLinux = None

    @staticmethod
    def get_isWindows():
        if (massive_sys_io_FileSys._isWindows is None):
            _this = Sys.systemName()
            startIndex = None
            massive_sys_io_FileSys._isWindows = (((_this.find("Win") if ((startIndex is None)) else HxString.indexOfImpl(_this,"Win",startIndex))) == 0)
        return massive_sys_io_FileSys._isWindows

    @staticmethod
    def get_isMac():
        if (massive_sys_io_FileSys._isMac is None):
            _this = Sys.systemName()
            startIndex = None
            massive_sys_io_FileSys._isMac = (((_this.find("Mac") if ((startIndex is None)) else HxString.indexOfImpl(_this,"Mac",startIndex))) == 0)
        return massive_sys_io_FileSys._isMac

    @staticmethod
    def get_isLinux():
        if (massive_sys_io_FileSys._isLinux is None):
            _this = Sys.systemName()
            startIndex = None
            massive_sys_io_FileSys._isLinux = (((_this.find("Linux") if ((startIndex is None)) else HxString.indexOfImpl(_this,"Linux",startIndex))) == 0)
        return massive_sys_io_FileSys._isLinux

    @staticmethod
    def safePath(path):
        if massive_sys_io_FileSys.get_isWindows():
            c = HxString.substr(path,-1,None)
            if ((c == "/") or ((c == "\\"))):
                path = HxString.substr(path,0,-1)
        return path

    @staticmethod
    def getCwd():
        path = Sys.getCwd()
        if massive_sys_io_FileSys.get_isWindows():
            if (HxString.substr(path,-1,None) == "/"):
                path = (HxOverrides.stringOrNull(HxString.substr(path,0,-1)) + "\\")
        return path

    @staticmethod
    def setCwd(path):
        path = massive_sys_io_FileSys.safePath(path)
        try:
            Sys.setCwd(path)
        except BaseException as _g:
            None
            e = haxe_Exception.caught(_g).unwrap()
            raise haxe_Exception.thrown(((Std.string(e) + "\n") + ("null" if path is None else path)))

    @staticmethod
    def exists(path):
        path = massive_sys_io_FileSys.safePath(path)
        try:
            return sys_FileSystem.exists(path)
        except BaseException as _g:
            None
            e = haxe_Exception.caught(_g).unwrap()
            raise haxe_Exception.thrown(((Std.string(e) + "\n") + ("null" if path is None else path)))

    @staticmethod
    def isDirectory(path):
        path = massive_sys_io_FileSys.safePath(path)
        try:
            return sys_FileSystem.isDirectory(path)
        except BaseException as _g:
            None
            e = haxe_Exception.caught(_g).unwrap()
            raise haxe_Exception.thrown(((Std.string(e) + "\n") + ("null" if path is None else path)))

    @staticmethod
    def readDirectory(path):
        path = massive_sys_io_FileSys.safePath(path)
        try:
            return sys_FileSystem.readDirectory(path)
        except BaseException as _g:
            None
            e = haxe_Exception.caught(_g).unwrap()
            raise haxe_Exception.thrown(((Std.string(e) + "\n") + ("null" if path is None else path)))

    @staticmethod
    def createDirectory(path):
        path = massive_sys_io_FileSys.safePath(path)
        try:
            sys_FileSystem.createDirectory(path)
        except BaseException as _g:
            None
            e = haxe_Exception.caught(_g).unwrap()
            raise haxe_Exception.thrown(((Std.string(e) + "\n") + ("null" if path is None else path)))

    @staticmethod
    def deleteDirectory(path):
        path = massive_sys_io_FileSys.safePath(path)
        try:
            sys_FileSystem.deleteDirectory(path)
        except BaseException as _g:
            None
            e = haxe_Exception.caught(_g).unwrap()
            raise haxe_Exception.thrown(((Std.string(e) + "\n") + ("null" if path is None else path)))

    @staticmethod
    def deleteFile(path):
        path = massive_sys_io_FileSys.safePath(path)
        try:
            sys_FileSystem.deleteFile(path)
        except BaseException as _g:
            None
            e = haxe_Exception.caught(_g).unwrap()
            raise haxe_Exception.thrown(((Std.string(e) + "\n") + ("null" if path is None else path)))
massive_sys_io_FileSys._hx_class = massive_sys_io_FileSys


class massive_sys_util_PathUtil:
    _hx_class_name = "massive.sys.util.PathUtil"
    __slots__ = ()
    _hx_statics = ["DIRECTORY_NAME", "HAXE_CLASS_NAME", "isAbsolutePath", "cleanUpPath", "lastCharIsSlash", "isRelativePath", "isValidDirectoryName", "isValidHaxeClassName"]

    def __init__(self):
        pass

    @staticmethod
    def isAbsolutePath(path):
        startIndex = None
        if (((path.find("/") if ((startIndex is None)) else HxString.indexOfImpl(path,"/",startIndex))) == 0):
            return True
        else:
            tmp = None
            startIndex = None
            if (((path.find("\\") if ((startIndex is None)) else HxString.indexOfImpl(path,"\\",startIndex))) > 0):
                startIndex = None
                tmp = (((path.find(":") if ((startIndex is None)) else HxString.indexOfImpl(path,":",startIndex))) == 1)
            else:
                tmp = False
            if tmp:
                return True
            else:
                return False

    @staticmethod
    def cleanUpPath(path):
        _this = Sys.getCwd()
        startIndex = None
        seperator = ("\\" if ((((_this.find("\\") if ((startIndex is None)) else HxString.indexOfImpl(_this,"\\",startIndex))) > 0)) else "/")
        if (seperator == "/"):
            _this = path.split("\\")
            path = seperator.join([python_Boot.toString1(x1,'') for x1 in _this])
        elif massive_sys_util_PathUtil.isAbsolutePath(path):
            _this = path.split("/")
            path = seperator.join([python_Boot.toString1(x1,'') for x1 in _this])
        else:
            _this = path.split("\\")
            path = seperator.join([python_Boot.toString1(x1,'') for x1 in _this])
        return path

    @staticmethod
    def lastCharIsSlash(path):
        l = (len(path) - 1)
        startIndex = None
        tmp = None
        if (startIndex is None):
            tmp = path.rfind("/", 0, len(path))
        else:
            i = path.rfind("/", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("/"))) if ((i == -1)) else (i + 1))
            check = path.find("/", startLeft, len(path))
            tmp = (check if (((check > i) and ((check <= startIndex)))) else i)
        if (tmp != l):
            startIndex = None
            tmp = None
            if (startIndex is None):
                tmp = path.rfind("\\", 0, len(path))
            else:
                i = path.rfind("\\", 0, (startIndex + 1))
                startLeft = (max(0,((startIndex + 1) - len("\\"))) if ((i == -1)) else (i + 1))
                check = path.find("\\", startLeft, len(path))
                tmp = (check if (((check > i) and ((check <= startIndex)))) else i)
            return (tmp == l)
        else:
            return True

    @staticmethod
    def isRelativePath(path):
        return (massive_sys_util_PathUtil.isAbsolutePath(path) == False)

    @staticmethod
    def isValidDirectoryName(path):
        _this = massive_sys_util_PathUtil.DIRECTORY_NAME
        _this.matchObj = python_lib_Re.search(_this.pattern,path)
        if (_this.matchObj is not None):
            return (massive_sys_util_PathUtil.DIRECTORY_NAME.matchObj.group(0) == path)
        else:
            return False

    @staticmethod
    def isValidHaxeClassName(path):
        _this = massive_sys_util_PathUtil.HAXE_CLASS_NAME
        _this.matchObj = python_lib_Re.search(_this.pattern,path)
        if (_this.matchObj is not None):
            return (massive_sys_util_PathUtil.HAXE_CLASS_NAME.matchObj.group(0) == path)
        else:
            return False
massive_sys_util_PathUtil._hx_class = massive_sys_util_PathUtil


class python_Boot:
    _hx_class_name = "python.Boot"
    __slots__ = ()
    _hx_statics = ["keywords", "_add_dynamic", "toString1", "fields", "simpleField", "hasField", "field", "getInstanceFields", "getSuperClass", "getClassFields", "prefixLength", "unhandleKeywords"]

    @staticmethod
    def _add_dynamic(a,b):
        if (isinstance(a,str) and isinstance(b,str)):
            return (a + b)
        if (isinstance(a,str) or isinstance(b,str)):
            return (python_Boot.toString1(a,"") + python_Boot.toString1(b,""))
        return (a + b)

    @staticmethod
    def toString1(o,s):
        if (o is None):
            return "null"
        if isinstance(o,str):
            return o
        if (s is None):
            s = ""
        if (len(s) >= 5):
            return "<...>"
        if isinstance(o,bool):
            if o:
                return "true"
            else:
                return "false"
        if (isinstance(o,int) and (not isinstance(o,bool))):
            return str(o)
        if isinstance(o,float):
            try:
                if (o == int(o)):
                    return str(Math.floor((o + 0.5)))
                else:
                    return str(o)
            except BaseException as _g:
                None
                return str(o)
        if isinstance(o,list):
            o1 = o
            l = len(o1)
            st = "["
            s = (("null" if s is None else s) + "\t")
            _g = 0
            _g1 = l
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                prefix = ""
                if (i > 0):
                    prefix = ","
                st = (("null" if st is None else st) + HxOverrides.stringOrNull(((("null" if prefix is None else prefix) + HxOverrides.stringOrNull(python_Boot.toString1((o1[i] if i >= 0 and i < len(o1) else None),s))))))
            st = (("null" if st is None else st) + "]")
            return st
        try:
            if hasattr(o,"toString"):
                return o.toString()
        except BaseException as _g:
            None
        if hasattr(o,"__class__"):
            if isinstance(o,_hx_AnonObject):
                toStr = None
                try:
                    fields = python_Boot.fields(o)
                    _g = []
                    _g1 = 0
                    while (_g1 < len(fields)):
                        f = (fields[_g1] if _g1 >= 0 and _g1 < len(fields) else None)
                        _g1 = (_g1 + 1)
                        x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
                        _g.append(x)
                    fieldsStr = _g
                    toStr = (("{ " + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " }")
                except BaseException as _g:
                    None
                    return "{ ... }"
                if (toStr is None):
                    return "{ ... }"
                else:
                    return toStr
            if isinstance(o,Enum):
                o1 = o
                l = len(o1.params)
                hasParams = (l > 0)
                if hasParams:
                    paramsStr = ""
                    _g = 0
                    _g1 = l
                    while (_g < _g1):
                        i = _g
                        _g = (_g + 1)
                        prefix = ""
                        if (i > 0):
                            prefix = ","
                        paramsStr = (("null" if paramsStr is None else paramsStr) + HxOverrides.stringOrNull(((("null" if prefix is None else prefix) + HxOverrides.stringOrNull(python_Boot.toString1(o1.params[i],s))))))
                    return (((HxOverrides.stringOrNull(o1.tag) + "(") + ("null" if paramsStr is None else paramsStr)) + ")")
                else:
                    return o1.tag
            if hasattr(o,"_hx_class_name"):
                if (o.__class__.__name__ != "type"):
                    fields = python_Boot.getInstanceFields(o)
                    _g = []
                    _g1 = 0
                    while (_g1 < len(fields)):
                        f = (fields[_g1] if _g1 >= 0 and _g1 < len(fields) else None)
                        _g1 = (_g1 + 1)
                        x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
                        _g.append(x)
                    fieldsStr = _g
                    toStr = (((HxOverrides.stringOrNull(o._hx_class_name) + "( ") + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " )")
                    return toStr
                else:
                    fields = python_Boot.getClassFields(o)
                    _g = []
                    _g1 = 0
                    while (_g1 < len(fields)):
                        f = (fields[_g1] if _g1 >= 0 and _g1 < len(fields) else None)
                        _g1 = (_g1 + 1)
                        x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
                        _g.append(x)
                    fieldsStr = _g
                    toStr = (((("#" + HxOverrides.stringOrNull(o._hx_class_name)) + "( ") + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " )")
                    return toStr
            if ((type(o) == type) and (o == str)):
                return "#String"
            if ((type(o) == type) and (o == list)):
                return "#Array"
            if callable(o):
                return "function"
            try:
                if hasattr(o,"__repr__"):
                    return o.__repr__()
            except BaseException as _g:
                None
            if hasattr(o,"__str__"):
                return o.__str__([])
            if hasattr(o,"__name__"):
                return o.__name__
            return "???"
        else:
            return str(o)

    @staticmethod
    def fields(o):
        a = []
        if (o is not None):
            if hasattr(o,"_hx_fields"):
                fields = o._hx_fields
                if (fields is not None):
                    return list(fields)
            if isinstance(o,_hx_AnonObject):
                d = o.__dict__
                keys = d.keys()
                handler = python_Boot.unhandleKeywords
                for k in keys:
                    if (k != '_hx_disable_getattr'):
                        a.append(handler(k))
            elif hasattr(o,"__dict__"):
                d = o.__dict__
                keys1 = d.keys()
                for k in keys1:
                    a.append(k)
        return a

    @staticmethod
    def simpleField(o,field):
        if (field is None):
            return None
        field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
        if hasattr(o,field1):
            return getattr(o,field1)
        else:
            return None

    @staticmethod
    def hasField(o,field):
        if isinstance(o,_hx_AnonObject):
            return o._hx_hasattr(field)
        return hasattr(o,(("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field)))

    @staticmethod
    def field(o,field):
        if (field is None):
            return None
        if isinstance(o,str):
            field1 = field
            _hx_local_0 = len(field1)
            if (_hx_local_0 == 10):
                if (field1 == "charCodeAt"):
                    return python_internal_MethodClosure(o,HxString.charCodeAt)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 11):
                if (field1 == "lastIndexOf"):
                    return python_internal_MethodClosure(o,HxString.lastIndexOf)
                elif (field1 == "toLowerCase"):
                    return python_internal_MethodClosure(o,HxString.toLowerCase)
                elif (field1 == "toUpperCase"):
                    return python_internal_MethodClosure(o,HxString.toUpperCase)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 9):
                if (field1 == "substring"):
                    return python_internal_MethodClosure(o,HxString.substring)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 5):
                if (field1 == "split"):
                    return python_internal_MethodClosure(o,HxString.split)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 7):
                if (field1 == "indexOf"):
                    return python_internal_MethodClosure(o,HxString.indexOf)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 8):
                if (field1 == "toString"):
                    return python_internal_MethodClosure(o,HxString.toString)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 6):
                if (field1 == "charAt"):
                    return python_internal_MethodClosure(o,HxString.charAt)
                elif (field1 == "length"):
                    return len(o)
                elif (field1 == "substr"):
                    return python_internal_MethodClosure(o,HxString.substr)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            else:
                field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                if hasattr(o,field1):
                    return getattr(o,field1)
                else:
                    return None
        elif isinstance(o,list):
            field1 = field
            _hx_local_1 = len(field1)
            if (_hx_local_1 == 11):
                if (field1 == "lastIndexOf"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.lastIndexOf)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 4):
                if (field1 == "copy"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.copy)
                elif (field1 == "join"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.join)
                elif (field1 == "push"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.push)
                elif (field1 == "sort"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.sort)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 5):
                if (field1 == "shift"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.shift)
                elif (field1 == "slice"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.slice)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 7):
                if (field1 == "indexOf"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.indexOf)
                elif (field1 == "reverse"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.reverse)
                elif (field1 == "unshift"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.unshift)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 3):
                if (field1 == "map"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.map)
                elif (field1 == "pop"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.pop)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 8):
                if (field1 == "contains"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.contains)
                elif (field1 == "iterator"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.iterator)
                elif (field1 == "toString"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.toString)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 16):
                if (field1 == "keyValueIterator"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.keyValueIterator)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 6):
                if (field1 == "concat"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.concat)
                elif (field1 == "filter"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.filter)
                elif (field1 == "insert"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.insert)
                elif (field1 == "length"):
                    return len(o)
                elif (field1 == "remove"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.remove)
                elif (field1 == "splice"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.splice)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            else:
                field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                if hasattr(o,field1):
                    return getattr(o,field1)
                else:
                    return None
        else:
            field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
            if hasattr(o,field1):
                return getattr(o,field1)
            else:
                return None

    @staticmethod
    def getInstanceFields(c):
        f = (list(c._hx_fields) if (hasattr(c,"_hx_fields")) else [])
        if hasattr(c,"_hx_methods"):
            f = (f + c._hx_methods)
        sc = python_Boot.getSuperClass(c)
        if (sc is None):
            return f
        else:
            scArr = python_Boot.getInstanceFields(sc)
            scMap = set(scArr)
            _g = 0
            while (_g < len(f)):
                f1 = (f[_g] if _g >= 0 and _g < len(f) else None)
                _g = (_g + 1)
                if (not (f1 in scMap)):
                    scArr.append(f1)
            return scArr

    @staticmethod
    def getSuperClass(c):
        if (c is None):
            return None
        try:
            if hasattr(c,"_hx_super"):
                return c._hx_super
            return None
        except BaseException as _g:
            None
        return None

    @staticmethod
    def getClassFields(c):
        if hasattr(c,"_hx_statics"):
            x = c._hx_statics
            return list(x)
        else:
            return []

    @staticmethod
    def unhandleKeywords(name):
        if (HxString.substr(name,0,python_Boot.prefixLength) == "_hx_"):
            real = HxString.substr(name,python_Boot.prefixLength,None)
            if (real in python_Boot.keywords):
                return real
        return name
python_Boot._hx_class = python_Boot


class python_HaxeIterator:
    _hx_class_name = "python.HaxeIterator"
    __slots__ = ("it", "x", "has", "checked")
    _hx_fields = ["it", "x", "has", "checked"]
    _hx_methods = ["next", "hasNext"]

    def __init__(self,it):
        self.checked = False
        self.has = False
        self.x = None
        self.it = it

    def next(self):
        if (not self.checked):
            self.hasNext()
        self.checked = False
        return self.x

    def hasNext(self):
        if (not self.checked):
            try:
                self.x = self.it.__next__()
                self.has = True
            except BaseException as _g:
                None
                if Std.isOfType(haxe_Exception.caught(_g).unwrap(),StopIteration):
                    self.has = False
                    self.x = None
                else:
                    raise _g
            self.checked = True
        return self.has

python_HaxeIterator._hx_class = python_HaxeIterator


class python__KwArgs_KwArgs_Impl_:
    _hx_class_name = "python._KwArgs.KwArgs_Impl_"
    __slots__ = ()
    _hx_statics = ["fromT"]

    @staticmethod
    def fromT(d):
        this1 = python_Lib.anonAsDict(d)
        return this1
python__KwArgs_KwArgs_Impl_._hx_class = python__KwArgs_KwArgs_Impl_


class python_Lib:
    _hx_class_name = "python.Lib"
    __slots__ = ()
    _hx_statics = ["lineEnd", "printString", "dictToAnon", "anonToDict", "anonAsDict"]

    @staticmethod
    def printString(_hx_str):
        encoding = "utf-8"
        if (encoding is None):
            encoding = "utf-8"
        python_lib_Sys.stdout.buffer.write(_hx_str.encode(encoding, "strict"))
        python_lib_Sys.stdout.flush()

    @staticmethod
    def dictToAnon(v):
        return _hx_AnonObject(v.copy())

    @staticmethod
    def anonToDict(o):
        if isinstance(o,_hx_AnonObject):
            return o.__dict__.copy()
        else:
            return None

    @staticmethod
    def anonAsDict(o):
        if isinstance(o,_hx_AnonObject):
            return o.__dict__
        else:
            return None
python_Lib._hx_class = python_Lib


class python_internal_ArrayImpl:
    _hx_class_name = "python.internal.ArrayImpl"
    __slots__ = ()
    _hx_statics = ["concat", "copy", "iterator", "keyValueIterator", "indexOf", "lastIndexOf", "join", "toString", "pop", "push", "unshift", "remove", "contains", "shift", "slice", "sort", "splice", "map", "filter", "insert", "reverse", "_get", "_set"]

    @staticmethod
    def concat(a1,a2):
        return (a1 + a2)

    @staticmethod
    def copy(x):
        return list(x)

    @staticmethod
    def iterator(x):
        return python_HaxeIterator(x.__iter__())

    @staticmethod
    def keyValueIterator(x):
        return haxe_iterators_ArrayKeyValueIterator(x)

    @staticmethod
    def indexOf(a,x,fromIndex = None):
        _hx_len = len(a)
        l = (0 if ((fromIndex is None)) else ((_hx_len + fromIndex) if ((fromIndex < 0)) else fromIndex))
        if (l < 0):
            l = 0
        _g = l
        _g1 = _hx_len
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            if HxOverrides.eq(a[i],x):
                return i
        return -1

    @staticmethod
    def lastIndexOf(a,x,fromIndex = None):
        _hx_len = len(a)
        l = (_hx_len if ((fromIndex is None)) else (((_hx_len + fromIndex) + 1) if ((fromIndex < 0)) else (fromIndex + 1)))
        if (l > _hx_len):
            l = _hx_len
        while True:
            l = (l - 1)
            tmp = l
            if (not ((tmp > -1))):
                break
            if HxOverrides.eq(a[l],x):
                return l
        return -1

    @staticmethod
    def join(x,sep):
        return sep.join([python_Boot.toString1(x1,'') for x1 in x])

    @staticmethod
    def toString(x):
        return (("[" + HxOverrides.stringOrNull(",".join([python_Boot.toString1(x1,'') for x1 in x]))) + "]")

    @staticmethod
    def pop(x):
        if (len(x) == 0):
            return None
        else:
            return x.pop()

    @staticmethod
    def push(x,e):
        x.append(e)
        return len(x)

    @staticmethod
    def unshift(x,e):
        x.insert(0, e)

    @staticmethod
    def remove(x,e):
        try:
            x.remove(e)
            return True
        except BaseException as _g:
            None
            return False

    @staticmethod
    def contains(x,e):
        return (e in x)

    @staticmethod
    def shift(x):
        if (len(x) == 0):
            return None
        return x.pop(0)

    @staticmethod
    def slice(x,pos,end = None):
        return x[pos:end]

    @staticmethod
    def sort(x,f):
        x.sort(key= python_lib_Functools.cmp_to_key(f))

    @staticmethod
    def splice(x,pos,_hx_len):
        if (pos < 0):
            pos = (len(x) + pos)
        if (pos < 0):
            pos = 0
        res = x[pos:(pos + _hx_len)]
        del x[pos:(pos + _hx_len)]
        return res

    @staticmethod
    def map(x,f):
        return list(map(f,x))

    @staticmethod
    def filter(x,f):
        return list(filter(f,x))

    @staticmethod
    def insert(a,pos,x):
        a.insert(pos, x)

    @staticmethod
    def reverse(a):
        a.reverse()

    @staticmethod
    def _get(x,idx):
        if ((idx > -1) and ((idx < len(x)))):
            return x[idx]
        else:
            return None

    @staticmethod
    def _set(x,idx,v):
        l = len(x)
        while (l < idx):
            x.append(None)
            l = (l + 1)
        if (l == idx):
            x.append(v)
        else:
            x[idx] = v
        return v
python_internal_ArrayImpl._hx_class = python_internal_ArrayImpl


class HxOverrides:
    _hx_class_name = "HxOverrides"
    __slots__ = ()
    _hx_statics = ["iterator", "eq", "stringOrNull", "toUpperCase", "rshift", "modf", "mod", "mapKwArgs"]

    @staticmethod
    def iterator(x):
        if isinstance(x,list):
            return haxe_iterators_ArrayIterator(x)
        return x.iterator()

    @staticmethod
    def eq(a,b):
        if (isinstance(a,list) or isinstance(b,list)):
            return a is b
        return (a == b)

    @staticmethod
    def stringOrNull(s):
        if (s is None):
            return "null"
        else:
            return s

    @staticmethod
    def toUpperCase(x):
        if isinstance(x,str):
            return x.upper()
        return x.toUpperCase()

    @staticmethod
    def rshift(val,n):
        return ((val % 0x100000000) >> n)

    @staticmethod
    def modf(a,b):
        if (b == 0.0):
            return float('nan')
        elif (a < 0):
            if (b < 0):
                return -(-a % (-b))
            else:
                return -(-a % b)
        elif (b < 0):
            return a % (-b)
        else:
            return a % b

    @staticmethod
    def mod(a,b):
        if (a < 0):
            if (b < 0):
                return -(-a % (-b))
            else:
                return -(-a % b)
        elif (b < 0):
            return a % (-b)
        else:
            return a % b

    @staticmethod
    def mapKwArgs(a,v):
        a1 = _hx_AnonObject(python_Lib.anonToDict(a))
        k = python_HaxeIterator(iter(v.keys()))
        while k.hasNext():
            k1 = k.next()
            val = v.get(k1)
            if a1._hx_hasattr(k1):
                x = getattr(a1,k1)
                setattr(a1,val,x)
                delattr(a1,k1)
        return a1
HxOverrides._hx_class = HxOverrides


class python_internal_MethodClosure:
    _hx_class_name = "python.internal.MethodClosure"
    __slots__ = ("obj", "func")
    _hx_fields = ["obj", "func"]
    _hx_methods = ["__call__"]

    def __init__(self,obj,func):
        self.obj = obj
        self.func = func

    def __call__(self,*args):
        return self.func(self.obj,*args)

python_internal_MethodClosure._hx_class = python_internal_MethodClosure


class HxString:
    _hx_class_name = "HxString"
    __slots__ = ()
    _hx_statics = ["split", "charCodeAt", "charAt", "lastIndexOf", "toUpperCase", "toLowerCase", "indexOf", "indexOfImpl", "toString", "substring", "substr"]

    @staticmethod
    def split(s,d):
        if (d == ""):
            return list(s)
        else:
            return s.split(d)

    @staticmethod
    def charCodeAt(s,index):
        if ((((s is None) or ((len(s) == 0))) or ((index < 0))) or ((index >= len(s)))):
            return None
        else:
            return ord(s[index])

    @staticmethod
    def charAt(s,index):
        if ((index < 0) or ((index >= len(s)))):
            return ""
        else:
            return s[index]

    @staticmethod
    def lastIndexOf(s,_hx_str,startIndex = None):
        if (startIndex is None):
            return s.rfind(_hx_str, 0, len(s))
        elif (_hx_str == ""):
            length = len(s)
            if (startIndex < 0):
                startIndex = (length + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            if (startIndex > length):
                return length
            else:
                return startIndex
        else:
            i = s.rfind(_hx_str, 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len(_hx_str))) if ((i == -1)) else (i + 1))
            check = s.find(_hx_str, startLeft, len(s))
            if ((check > i) and ((check <= startIndex))):
                return check
            else:
                return i

    @staticmethod
    def toUpperCase(s):
        return s.upper()

    @staticmethod
    def toLowerCase(s):
        return s.lower()

    @staticmethod
    def indexOf(s,_hx_str,startIndex = None):
        if (startIndex is None):
            return s.find(_hx_str)
        else:
            return HxString.indexOfImpl(s,_hx_str,startIndex)

    @staticmethod
    def indexOfImpl(s,_hx_str,startIndex):
        if (_hx_str == ""):
            length = len(s)
            if (startIndex < 0):
                startIndex = (length + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            if (startIndex > length):
                return length
            else:
                return startIndex
        return s.find(_hx_str, startIndex)

    @staticmethod
    def toString(s):
        return s

    @staticmethod
    def substring(s,startIndex,endIndex = None):
        if (startIndex < 0):
            startIndex = 0
        if (endIndex is None):
            return s[startIndex:]
        else:
            if (endIndex < 0):
                endIndex = 0
            if (endIndex < startIndex):
                return s[endIndex:startIndex]
            else:
                return s[startIndex:endIndex]

    @staticmethod
    def substr(s,startIndex,_hx_len = None):
        if (_hx_len is None):
            return s[startIndex:]
        else:
            if (_hx_len == 0):
                return ""
            if (startIndex < 0):
                startIndex = (len(s) + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            return s[startIndex:(startIndex + _hx_len)]
HxString._hx_class = HxString


class python_io_NativeInput(haxe_io_Input):
    _hx_class_name = "python.io.NativeInput"
    __slots__ = ("stream", "wasEof")
    _hx_fields = ["stream", "wasEof"]
    _hx_methods = ["close", "throwEof", "readinto", "readBytes"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Input


    def __init__(self,s):
        self.wasEof = None
        self.stream = s
        self.set_bigEndian(False)
        self.wasEof = False
        if (not self.stream.readable()):
            raise haxe_Exception.thrown("Write-only stream")

    def close(self):
        self.stream.close()

    def throwEof(self):
        self.wasEof = True
        raise haxe_Exception.thrown(haxe_io_Eof())

    def readinto(self,b):
        raise haxe_Exception.thrown("abstract method, should be overridden")

    def readBytes(self,s,pos,_hx_len):
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > s.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        ba = bytearray(_hx_len)
        ret = self.readinto(ba)
        if (ret == 0):
            self.throwEof()
        s.blit(pos,haxe_io_Bytes.ofData(ba),0,_hx_len)
        return ret

python_io_NativeInput._hx_class = python_io_NativeInput


class python_io_IInput:
    _hx_class_name = "python.io.IInput"
    __slots__ = ("bigEndian",)
    _hx_fields = ["bigEndian"]
    _hx_methods = ["set_bigEndian", "readByte", "readBytes", "close", "readAll", "readLine"]
python_io_IInput._hx_class = python_io_IInput


class python_io_NativeBytesInput(python_io_NativeInput):
    _hx_class_name = "python.io.NativeBytesInput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["readByte", "readinto"]
    _hx_statics = []
    _hx_interfaces = [python_io_IInput]
    _hx_super = python_io_NativeInput


    def __init__(self,stream):
        super().__init__(stream)

    def readByte(self):
        ret = self.stream.read(1)
        if (len(ret) == 0):
            self.throwEof()
        return ret[0]

    def readinto(self,b):
        return self.stream.readinto(b)

python_io_NativeBytesInput._hx_class = python_io_NativeBytesInput


class python_io_IFileInput:
    _hx_class_name = "python.io.IFileInput"
    __slots__ = ()
    _hx_interfaces = [python_io_IInput]
python_io_IFileInput._hx_class = python_io_IFileInput


class python_io_FileBytesInput(python_io_NativeBytesInput):
    _hx_class_name = "python.io.FileBytesInput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = [python_io_IFileInput]
    _hx_super = python_io_NativeBytesInput


    def __init__(self,stream):
        super().__init__(stream)
python_io_FileBytesInput._hx_class = python_io_FileBytesInput


class python_io_NativeOutput(haxe_io_Output):
    _hx_class_name = "python.io.NativeOutput"
    __slots__ = ("stream",)
    _hx_fields = ["stream"]
    _hx_methods = ["close", "flush"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Output


    def __init__(self,stream):
        self.stream = None
        self.set_bigEndian(False)
        self.stream = stream
        if (not stream.writable()):
            raise haxe_Exception.thrown("Read only stream")

    def close(self):
        self.stream.close()

    def flush(self):
        self.stream.flush()

python_io_NativeOutput._hx_class = python_io_NativeOutput


class python_io_NativeBytesOutput(python_io_NativeOutput):
    _hx_class_name = "python.io.NativeBytesOutput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["writeByte", "writeBytes"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = python_io_NativeOutput


    def __init__(self,stream):
        super().__init__(stream)

    def writeByte(self,c):
        self.stream.write(bytearray([c]))

    def writeBytes(self,s,pos,_hx_len):
        return self.stream.write(s.b[pos:(pos + _hx_len)])

python_io_NativeBytesOutput._hx_class = python_io_NativeBytesOutput


class python_io_IOutput:
    _hx_class_name = "python.io.IOutput"
    __slots__ = ("bigEndian",)
    _hx_fields = ["bigEndian"]
    _hx_methods = ["set_bigEndian", "writeByte", "writeBytes", "flush", "close", "write", "writeFullBytes", "writeUInt16", "writeInt32", "writeString"]
python_io_IOutput._hx_class = python_io_IOutput


class python_io_IFileOutput:
    _hx_class_name = "python.io.IFileOutput"
    __slots__ = ()
    _hx_interfaces = [python_io_IOutput]
python_io_IFileOutput._hx_class = python_io_IFileOutput


class python_io_FileBytesOutput(python_io_NativeBytesOutput):
    _hx_class_name = "python.io.FileBytesOutput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = [python_io_IFileOutput]
    _hx_super = python_io_NativeBytesOutput


    def __init__(self,stream):
        super().__init__(stream)
python_io_FileBytesOutput._hx_class = python_io_FileBytesOutput


class python_io_NativeTextInput(python_io_NativeInput):
    _hx_class_name = "python.io.NativeTextInput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["readByte", "readinto"]
    _hx_statics = []
    _hx_interfaces = [python_io_IInput]
    _hx_super = python_io_NativeInput


    def __init__(self,stream):
        super().__init__(stream)

    def readByte(self):
        ret = self.stream.buffer.read(1)
        if (len(ret) == 0):
            self.throwEof()
        return ret[0]

    def readinto(self,b):
        return self.stream.buffer.readinto(b)

python_io_NativeTextInput._hx_class = python_io_NativeTextInput


class python_io_FileTextInput(python_io_NativeTextInput):
    _hx_class_name = "python.io.FileTextInput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = [python_io_IFileInput]
    _hx_super = python_io_NativeTextInput


    def __init__(self,stream):
        super().__init__(stream)
python_io_FileTextInput._hx_class = python_io_FileTextInput


class python_io_NativeTextOutput(python_io_NativeOutput):
    _hx_class_name = "python.io.NativeTextOutput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["writeBytes", "writeByte"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = python_io_NativeOutput


    def __init__(self,stream):
        super().__init__(stream)
        if (not stream.writable()):
            raise haxe_Exception.thrown("Read only stream")

    def writeBytes(self,s,pos,_hx_len):
        return self.stream.buffer.write(s.b[pos:(pos + _hx_len)])

    def writeByte(self,c):
        self.stream.write("".join(map(chr,[c])))

python_io_NativeTextOutput._hx_class = python_io_NativeTextOutput


class python_io_FileTextOutput(python_io_NativeTextOutput):
    _hx_class_name = "python.io.FileTextOutput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = [python_io_IFileOutput]
    _hx_super = python_io_NativeTextOutput


    def __init__(self,stream):
        super().__init__(stream)
python_io_FileTextOutput._hx_class = python_io_FileTextOutput


class python_io_IoTools:
    _hx_class_name = "python.io.IoTools"
    __slots__ = ()
    _hx_statics = ["createFileInputFromText", "createFileInputFromBytes", "createFileOutputFromText", "createFileOutputFromBytes"]

    @staticmethod
    def createFileInputFromText(t):
        return sys_io_FileInput(python_io_FileTextInput(t))

    @staticmethod
    def createFileInputFromBytes(t):
        return sys_io_FileInput(python_io_FileBytesInput(t))

    @staticmethod
    def createFileOutputFromText(t):
        return sys_io_FileOutput(python_io_FileTextOutput(t))

    @staticmethod
    def createFileOutputFromBytes(t):
        return sys_io_FileOutput(python_io_FileBytesOutput(t))
python_io_IoTools._hx_class = python_io_IoTools


class sys_io_File:
    _hx_class_name = "sys.io.File"
    __slots__ = ()
    _hx_statics = ["getContent", "saveContent", "getBytes", "saveBytes", "read", "write", "copy"]

    @staticmethod
    def getContent(path):
        f = python_lib_Builtins.open(path,"r",-1,"utf-8",None,"")
        content = f.read(-1)
        f.close()
        return content

    @staticmethod
    def saveContent(path,content):
        f = python_lib_Builtins.open(path,"w",-1,"utf-8",None,"")
        f.write(content)
        f.close()

    @staticmethod
    def getBytes(path):
        f = python_lib_Builtins.open(path,"rb",-1)
        size = f.read(-1)
        b = haxe_io_Bytes.ofData(size)
        f.close()
        return b

    @staticmethod
    def saveBytes(path,_hx_bytes):
        f = python_lib_Builtins.open(path,"wb",-1)
        f.write(_hx_bytes.b)
        f.close()

    @staticmethod
    def read(path,binary = None):
        if (binary is None):
            binary = True
        mode = ("rb" if binary else "r")
        f = python_lib_Builtins.open(path,mode,-1,None,None,(None if binary else ""))
        if binary:
            return python_io_IoTools.createFileInputFromBytes(f)
        else:
            return python_io_IoTools.createFileInputFromText(f)

    @staticmethod
    def write(path,binary = None):
        if (binary is None):
            binary = True
        mode = ("wb" if binary else "w")
        f = python_lib_Builtins.open(path,mode,-1,None,None,(None if binary else ""))
        if binary:
            return python_io_IoTools.createFileOutputFromBytes(f)
        else:
            return python_io_IoTools.createFileOutputFromText(f)

    @staticmethod
    def copy(srcPath,dstPath):
        python_lib_Shutil.copy(srcPath,dstPath)
sys_io_File._hx_class = sys_io_File


class sys_io_FileInput(haxe_io_Input):
    _hx_class_name = "sys.io.FileInput"
    __slots__ = ("impl",)
    _hx_fields = ["impl"]
    _hx_methods = ["set_bigEndian", "readByte", "readBytes", "close", "readAll", "readLine"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Input


    def __init__(self,impl):
        self.impl = impl

    def set_bigEndian(self,b):
        return self.impl.set_bigEndian(b)

    def readByte(self):
        return self.impl.readByte()

    def readBytes(self,s,pos,_hx_len):
        return self.impl.readBytes(s,pos,_hx_len)

    def close(self):
        self.impl.close()

    def readAll(self,bufsize = None):
        return self.impl.readAll(bufsize)

    def readLine(self):
        return self.impl.readLine()

sys_io_FileInput._hx_class = sys_io_FileInput


class sys_io_FileOutput(haxe_io_Output):
    _hx_class_name = "sys.io.FileOutput"
    __slots__ = ("impl",)
    _hx_fields = ["impl"]
    _hx_methods = ["set_bigEndian", "writeByte", "writeBytes", "flush", "close", "write", "writeFullBytes", "writeUInt16", "writeInt32", "writeString"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Output


    def __init__(self,impl):
        self.impl = impl

    def set_bigEndian(self,b):
        return self.impl.set_bigEndian(b)

    def writeByte(self,c):
        self.impl.writeByte(c)

    def writeBytes(self,s,pos,_hx_len):
        return self.impl.writeBytes(s,pos,_hx_len)

    def flush(self):
        self.impl.flush()

    def close(self):
        self.impl.close()

    def write(self,s):
        self.impl.write(s)

    def writeFullBytes(self,s,pos,_hx_len):
        self.impl.writeFullBytes(s,pos,_hx_len)

    def writeUInt16(self,x):
        self.impl.writeUInt16(x)

    def writeInt32(self,x):
        self.impl.writeInt32(x)

    def writeString(self,s,encoding = None):
        self.impl.writeString(s)

sys_io_FileOutput._hx_class = sys_io_FileOutput


class sys_io_Process:
    _hx_class_name = "sys.io.Process"
    __slots__ = ("stdout", "stderr", "stdin", "p")
    _hx_fields = ["stdout", "stderr", "stdin", "p"]
    _hx_methods = ["exitCode", "close"]

    def __init__(self,cmd,args = None,detached = None):
        self.stdin = None
        self.stderr = None
        self.stdout = None
        if detached:
            raise haxe_Exception.thrown("Detached process is not supported on this platform")
        args1 = (cmd if ((args is None)) else ([cmd] + args))
        o = _hx_AnonObject({'shell': (args is None), 'stdin': python_lib_Subprocess.PIPE, 'stdout': python_lib_Subprocess.PIPE, 'stderr': python_lib_Subprocess.PIPE})
        Reflect.setField(o,"bufsize",(Reflect.field(o,"bufsize") if (python_Boot.hasField(o,"bufsize")) else 0))
        Reflect.setField(o,"executable",(Reflect.field(o,"executable") if (python_Boot.hasField(o,"executable")) else None))
        Reflect.setField(o,"stdin",(Reflect.field(o,"stdin") if (python_Boot.hasField(o,"stdin")) else None))
        Reflect.setField(o,"stdout",(Reflect.field(o,"stdout") if (python_Boot.hasField(o,"stdout")) else None))
        Reflect.setField(o,"stderr",(Reflect.field(o,"stderr") if (python_Boot.hasField(o,"stderr")) else None))
        Reflect.setField(o,"preexec_fn",(Reflect.field(o,"preexec_fn") if (python_Boot.hasField(o,"preexec_fn")) else None))
        Reflect.setField(o,"close_fds",(Reflect.field(o,"close_fds") if (python_Boot.hasField(o,"close_fds")) else None))
        Reflect.setField(o,"shell",(Reflect.field(o,"shell") if (python_Boot.hasField(o,"shell")) else None))
        Reflect.setField(o,"cwd",(Reflect.field(o,"cwd") if (python_Boot.hasField(o,"cwd")) else None))
        Reflect.setField(o,"env",(Reflect.field(o,"env") if (python_Boot.hasField(o,"env")) else None))
        Reflect.setField(o,"universal_newlines",(Reflect.field(o,"universal_newlines") if (python_Boot.hasField(o,"universal_newlines")) else None))
        Reflect.setField(o,"startupinfo",(Reflect.field(o,"startupinfo") if (python_Boot.hasField(o,"startupinfo")) else None))
        Reflect.setField(o,"creationflags",(Reflect.field(o,"creationflags") if (python_Boot.hasField(o,"creationflags")) else 0))
        self.p = (python_lib_subprocess_Popen(args1,Reflect.field(o,"bufsize"),Reflect.field(o,"executable"),Reflect.field(o,"stdin"),Reflect.field(o,"stdout"),Reflect.field(o,"stderr"),Reflect.field(o,"preexec_fn"),Reflect.field(o,"close_fds"),Reflect.field(o,"shell"),Reflect.field(o,"cwd"),Reflect.field(o,"env"),Reflect.field(o,"universal_newlines"),Reflect.field(o,"startupinfo"),Reflect.field(o,"creationflags")) if ((Sys.systemName() == "Windows")) else python_lib_subprocess_Popen(args1,Reflect.field(o,"bufsize"),Reflect.field(o,"executable"),Reflect.field(o,"stdin"),Reflect.field(o,"stdout"),Reflect.field(o,"stderr"),Reflect.field(o,"preexec_fn"),Reflect.field(o,"close_fds"),Reflect.field(o,"shell"),Reflect.field(o,"cwd"),Reflect.field(o,"env"),Reflect.field(o,"universal_newlines"),Reflect.field(o,"startupinfo")))
        self.stdout = python_io_IoTools.createFileInputFromText(python_lib_io_TextIOWrapper(python_lib_io_BufferedReader(self.p.stdout)))
        self.stderr = python_io_IoTools.createFileInputFromText(python_lib_io_TextIOWrapper(python_lib_io_BufferedReader(self.p.stderr)))
        self.stdin = python_io_IoTools.createFileOutputFromText(python_lib_io_TextIOWrapper(python_lib_io_BufferedWriter(self.p.stdin)))

    def exitCode(self,block = None):
        if (block is None):
            block = True
        if (block == False):
            return self.p.poll()
        return self.p.wait()

    def close(self):
        ver = python_lib_Sys.version_info
        if ((ver[0] > 3) or (((ver[0] == 3) and ((ver[1] >= 3))))):
            try:
                self.p.terminate()
            except BaseException as _g:
                None
                if (not Std.isOfType(haxe_Exception.caught(_g).unwrap(),ProcessLookupError)):
                    raise _g
        else:
            try:
                self.p.terminate()
            except BaseException as _g:
                None
                if (not Std.isOfType(haxe_Exception.caught(_g).unwrap(),OSError)):
                    raise _g

sys_io_Process._hx_class = sys_io_Process


class sys_net_Host:
    _hx_class_name = "sys.net.Host"
    __slots__ = ("host", "name")
    _hx_fields = ["host", "name"]
    _hx_methods = ["toString"]

    def __init__(self,name):
        self.host = name
        self.name = name

    def toString(self):
        return self.name

sys_net_Host._hx_class = sys_net_Host


class sys_net__Socket_SocketInput(haxe_io_Input):
    _hx_class_name = "sys.net._Socket.SocketInput"
    __slots__ = ("_hx___s",)
    _hx_fields = ["__s"]
    _hx_methods = ["readByte", "readBytes"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Input


    def __init__(self,s):
        self._hx___s = s

    def readByte(self):
        r = None
        try:
            r = self._hx___s.recv(1,0)
        except BaseException as _g:
            None
            if Std.isOfType(haxe_Exception.caught(_g).unwrap(),BlockingIOError):
                raise haxe_Exception.thrown(haxe_io_Error.Blocked)
            else:
                raise _g
        if (len(r) == 0):
            raise haxe_Exception.thrown(haxe_io_Eof())
        return r[0]

    def readBytes(self,buf,pos,_hx_len):
        r = None
        data = buf.b
        try:
            r = self._hx___s.recv(_hx_len,0)
            _g = pos
            _g1 = (pos + len(r))
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                data.__setitem__(i,r[(i - pos)])
        except BaseException as _g:
            None
            if Std.isOfType(haxe_Exception.caught(_g).unwrap(),BlockingIOError):
                raise haxe_Exception.thrown(haxe_io_Error.Blocked)
            else:
                raise _g
        if (len(r) == 0):
            raise haxe_Exception.thrown(haxe_io_Eof())
        return len(r)

sys_net__Socket_SocketInput._hx_class = sys_net__Socket_SocketInput


class sys_net__Socket_SocketOutput(haxe_io_Output):
    _hx_class_name = "sys.net._Socket.SocketOutput"
    __slots__ = ("_hx___s",)
    _hx_fields = ["__s"]
    _hx_methods = ["writeByte", "writeBytes"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Output


    def __init__(self,s):
        self._hx___s = s

    def writeByte(self,c):
        try:
            self._hx___s.send(bytes([c]),0)
        except BaseException as _g:
            None
            if Std.isOfType(haxe_Exception.caught(_g).unwrap(),BlockingIOError):
                raise haxe_Exception.thrown(haxe_io_Error.Blocked)
            else:
                raise _g

    def writeBytes(self,buf,pos,_hx_len):
        try:
            data = buf.b
            payload = data[pos:pos+_hx_len]
            r = self._hx___s.send(payload,0)
            return r
        except BaseException as _g:
            None
            if Std.isOfType(haxe_Exception.caught(_g).unwrap(),BlockingIOError):
                raise haxe_Exception.thrown(haxe_io_Error.Blocked)
            else:
                raise _g

sys_net__Socket_SocketOutput._hx_class = sys_net__Socket_SocketOutput


class sys_net_Socket:
    _hx_class_name = "sys.net.Socket"
    __slots__ = ("_hx___s", "input", "output")
    _hx_fields = ["__s", "input", "output"]
    _hx_methods = ["__initSocket", "read", "connect", "waitForRead", "fileno"]

    def __init__(self):
        self.output = None
        self.input = None
        self._hx___s = None
        self._hx___initSocket()
        self.input = sys_net__Socket_SocketInput(self._hx___s)
        self.output = sys_net__Socket_SocketOutput(self._hx___s)

    def _hx___initSocket(self):
        self._hx___s = python_lib_socket_Socket()

    def read(self):
        return self.input.readAll().toString()

    def connect(self,host,port):
        host_str = host.toString()
        self._hx___s.connect((host_str, port))

    def waitForRead(self):
        python_lib_Select.select([self],[],[])

    def fileno(self):
        return self._hx___s.fileno()

sys_net_Socket._hx_class = sys_net_Socket


class utils_DisplayInfo:
    _hx_class_name = "utils.DisplayInfo"
    __slots__ = ()

    def __init__(self,commands):
        if (hxp_System.get_hostPlatform() == "windows"):
            hxp_Log.println("")
        hxp_Log.println("\x1B[31m @@@@@@   @@@@@@@    @@@@@@    @@@@@@   @@@@@@@   @@@ @@@ \x1B[0m")
        hxp_Log.println("\x1B[31m@@@@@@@   @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@ @@@ \x1B[0m")
        hxp_Log.println("\x1B[31m!@@       @@!  @@@  @@!  @@@  @@!  @@@  @@!  @@@  @@! !@@ \x1B[0m")
        hxp_Log.println("\x1B[31m!@!       !@!  @!@  !@!  @!@  !@!  @!@  !@!  @!@  !@! @!! \x1B[0m")
        hxp_Log.println("\x1B[31m!!@@!!    @!@@!@!   @!@  !@!  @!@  !@!  @!@@!@!    !@!@!   \x1B[0m")
        hxp_Log.println("\x1B[31m !!@!!!   !!@!!!    !@!  !!!  !@!  !!!  !!@!!!      @!!!   \x1B[0m")
        hxp_Log.println("\x1B[31m     !:!  !!:       !!:  !!!  !!:  !!!  !!:         !!:    \x1B[0m")
        hxp_Log.println("\x1B[31m    !:!   :!:       :!:  !:!  :!:  !:!  :!:         :!:    \x1B[0m")
        hxp_Log.println("\x1B[31m:::: ::    ::       ::::: ::  ::::: ::   ::          ::    \x1B[0m")
        hxp_Log.println("\x1B[31m:: : :     :         : :  :    : :  :    :           :     \x1B[0m")
        hxp_Log.println("")
        hxp_Log.println("")
        hxp_Log.println("\x1B[1mSpoopy Engine Command-Line Tools \x1B[0m")
        hxp_Log.println("")
        hxp_Log.println("\x1B[31m\x1B[1m  Available commands:\x1B[0m")
        hxp_Log.println("")
        _g = 0
        while (_g < len(commands)):
            cmd = (commands[_g] if _g >= 0 and _g < len(commands) else None)
            _g = (_g + 1)
            hxp_Log.println(((("    \x1B[1m" + HxOverrides.stringOrNull(cmd.name)) + "\x1B[0m -- ") + HxOverrides.stringOrNull(cmd.description)))
        hxp_Log.println("")
utils_DisplayInfo._hx_class = utils_DisplayInfo


class utils_PathUtils:
    _hx_class_name = "utils.PathUtils"
    __slots__ = ()
    _hx_statics = ["getHaxelibPath", "combine", "recursivelyFindFile"]

    @staticmethod
    def getHaxelibPath(name):
        proc = sys_io_Process("haxelib",["path", name])
        result = ""
        try:
            previous = ""
            while True:
                line = proc.stdout.readLine()
                if line.startswith(("-D " + ("null" if name is None else name))):
                    result = previous
                    break
                previous = line
        except BaseException as _g:
            None
        proc.close()
        return result

    @staticmethod
    def combine(firstPath,secondPath):
        if ((firstPath is None) or ((firstPath == ""))):
            return secondPath
        elif ((secondPath is not None) and ((secondPath != ""))):
            if massive_sys_io_FileSys.get_isWindows():
                startIndex = None
                if (((secondPath.find(":") if ((startIndex is None)) else HxString.indexOfImpl(secondPath,":",startIndex))) == 1):
                    return secondPath
            elif (HxString.substr(secondPath,0,1) == "/"):
                return secondPath
            firstSlash = ((HxString.substr(firstPath,-1,None) == "/") or ((HxString.substr(firstPath,-1,None) == "\\")))
            secondSlash = ((HxString.substr(secondPath,0,1) == "/") or ((HxString.substr(secondPath,0,1) == "\\")))
            if (firstSlash and secondSlash):
                return (("null" if firstPath is None else firstPath) + HxOverrides.stringOrNull(HxString.substr(secondPath,1,None)))
            elif ((not firstSlash) and (not secondSlash)):
                return ((("null" if firstPath is None else firstPath) + "/") + ("null" if secondPath is None else secondPath))
            else:
                return (("null" if firstPath is None else firstPath) + ("null" if secondPath is None else secondPath))
        return firstPath

    @staticmethod
    def recursivelyFindFile(path,file):
        folderIn = path
        listOfFiles = sys_FileSystem.readDirectory(path)
        _g = 0
        while (_g < len(listOfFiles)):
            fileInFolder = (listOfFiles[_g] if _g >= 0 and _g < len(listOfFiles) else None)
            _g = (_g + 1)
            if (not sys_FileSystem.isDirectory(((("null" if path is None else path) + "/") + ("null" if fileInFolder is None else fileInFolder)))):
                if (fileInFolder == file):
                    return ((("null" if folderIn is None else folderIn) + "/") + ("null" if file is None else file))
        _g = 0
        while (_g < len(listOfFiles)):
            fileInFolder = (listOfFiles[_g] if _g >= 0 and _g < len(listOfFiles) else None)
            _g = (_g + 1)
            if sys_FileSystem.isDirectory(((("null" if path is None else path) + "/") + ("null" if fileInFolder is None else fileInFolder))):
                folderIn = utils_PathUtils.recursivelyFindFile(((("null" if path is None else path) + "/") + ("null" if fileInFolder is None else fileInFolder)),file)
                if ((folderIn is None) or ((folderIn == ""))):
                    folderIn = path
                else:
                    return folderIn
        return ""
utils_PathUtils._hx_class = utils_PathUtils


class utils_net_GitFileManager:
    _hx_class_name = "utils.net.GitFileManager"
    __slots__ = ()
    _hx_statics = ["download"]

    @staticmethod
    def download(url,downloadPath):
        host = sys_net_Host("github.com")
        gitSocket = sys_net_Socket()
        gitSocket.connect(host,443)
        gitSocket.waitForRead()
        hxp_Log.info(gitSocket.read())
utils_net_GitFileManager._hx_class = utils_net_GitFileManager

Math.NEGATIVE_INFINITY = float("-inf")
Math.POSITIVE_INFINITY = float("inf")
Math.NaN = float("nan")
Math.PI = python_lib_Math.pi
_g = haxe_ds_StringMap()
_g.h["jpg"] = False
_g.h["jpeg"] = False
_g.h["png"] = False
_g.h["gif"] = False
_g.h["webp"] = False
_g.h["bmp"] = False
_g.h["tiff"] = False
_g.h["jfif"] = False
_g.h["otf"] = False
_g.h["ttf"] = False
_g.h["wav"] = False
_g.h["wave"] = False
_g.h["mp3"] = False
_g.h["mp2"] = False
_g.h["exe"] = False
_g.h["bin"] = False
_g.h["so"] = False
_g.h["pch"] = False
_g.h["dll"] = False
_g.h["zip"] = False
_g.h["tar"] = False
_g.h["gz"] = False
_g.h["fla"] = False
_g.h["swf"] = False
_g.h["atf"] = False
_g.h["psd"] = False
_g.h["awd"] = False
_g.h["txt"] = True
_g.h["text"] = True
_g.h["xml"] = True
_g.h["java"] = True
_g.h["hx"] = True
_g.h["cpp"] = True
_g.h["c"] = True
_g.h["h"] = True
_g.h["cs"] = True
_g.h["js"] = True
_g.h["mm"] = True
_g.h["hxml"] = True
_g.h["html"] = True
_g.h["json"] = True
_g.h["css"] = True
_g.h["gpe"] = True
_g.h["pbxproj"] = True
_g.h["plist"] = True
_g.h["properties"] = True
_g.h["ini"] = True
_g.h["hxproj"] = True
_g.h["nmml"] = True
_g.h["lime"] = True
_g.h["svg"] = True
hxp_System._isText = _g

RunScript.haxeLibPath = ""
RunScript.projectCMDS = ["test"]
RunScript.runFromHaxelib = False
RunScript.debug = False
RunScript.commandList = [_hx_AnonObject({'name': "build_ndll", 'description': "Build a dynamic link library for Spoopy Engine."}), _hx_AnonObject({'name': "import_ndll", 'description': "Import a dynamic link library from git for Spoopy Engine as a module."}), _hx_AnonObject({'name': "destroy_ndll", 'description': "Destroy a dynamic link library from Spoopy Engine."}), _hx_AnonObject({'name': "update", 'description': "Refresh and upgrade the components within Spoopy Engine."}), _hx_AnonObject({'name': "setup", 'description': "Setup spoopy library."}), _hx_AnonObject({'name': "create", 'description': "Create a new project."}), _hx_AnonObject({'name': "test", 'description': "Build and run project."}), _hx_AnonObject({'name': "ls", 'description': "List the files and directories in Spoopy Engine's source directory."})]
haxe_Template.splitter = EReg("(::[A-Za-z0-9_ ()&|!+=/><*.\"-]+::|\\$\\$([A-Za-z0-9_-]+)\\()","")
haxe_Template.expr_splitter = EReg("(\\(|\\)|[ \r\n\t]*\"[^\"]*\"[ \r\n\t]*|[!+=/><*.&|-]+)","")
haxe_Template.expr_trim = EReg("^[ ]*([^ ]+)[ ]*$","")
haxe_Template.expr_int = EReg("^[0-9]+$","")
haxe_Template.expr_float = EReg("^([+-]?)(?=\\d|,\\d)\\d*(,\\d*)?([Ee]([+-]?\\d+))?$","")
haxe_Template.globals = _hx_AnonObject({})
haxe_Template.hxKeepArrayIterator = haxe_iterators_ArrayIterator([])
hxp_Haxelib.debug = False
hxp_Haxelib.pathOverrides = haxe_ds_StringMap()
hxp_Haxelib.workingDirectory = ""
hxp_Haxelib.paths = haxe_ds_StringMap()
hxp_Haxelib.toolPath = None
hxp_Haxelib.versions = haxe_ds_StringMap()
hxp_Log.accentColor = "\x1B[36;1m"
hxp_Log.enableColor = True
hxp_Log.mute = False
hxp_Log.resetColor = "\x1B[0m"
hxp_Log.verbose = False
hxp_Log.colorCodes = EReg("\\x1b\\[[^m]+m","g")
hxp_Log.sentWarnings = haxe_ds_StringMap()
hxp_StringTools.seedNumber = 0
hxp_StringTools.base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
hxp_StringTools.usedFlatNames = haxe_ds_StringMap()
hxp_StringTools.uuidChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
hxp_System.dryRun = False
hxp_System._processorCores = 0
hxp__Version_Version_Impl_.VERSION = EReg("^(\\d+)\\.(\\d+)\\.(\\d+)(?:[-]([a-z0-9.-]+))?(?:[+]([a-z0-9.-]+))?$","i")
hxp__Version_Version_Impl_.SANITIZER = EReg("[^0-9A-Za-z-]","g")
hxp__Version_VersionRule_Impl_.VERSION = EReg("^(>=|<=|[v=><~^])?(\\d+|[x*])(?:\\.(\\d+|[x*]))?(?:\\.(\\d+|[x*]))?(?:[-]([a-z0-9.-]+))?(?:[+]([a-z0-9.-]+))?$","i")
hxp__Version_VersionRule_Impl_.IS_DIGITS = EReg("^\\d+$","")
massive_haxe_log_Log.logLevel = massive_haxe_log_LogLevel.console
massive_haxe_log_Log.logClient = massive_haxe_log_LogClient()
massive_sys_io_File.tempCount = 0
massive_sys_io_File.temp = haxe_ds_StringMap()
massive_sys_util_PathUtil.DIRECTORY_NAME = EReg("\\.?[a-zA-Z0-9\\-_ ]*$","")
massive_sys_util_PathUtil.HAXE_CLASS_NAME = EReg("[A-Z]([a-zA-Z0-9]+)\\.hx","")
python_Boot.keywords = set(["and", "del", "from", "not", "with", "as", "elif", "global", "or", "yield", "assert", "else", "if", "pass", "None", "break", "except", "import", "raise", "True", "class", "exec", "in", "return", "False", "continue", "finally", "is", "try", "def", "for", "lambda", "while"])
python_Boot.prefixLength = len("_hx_")
python_Lib.lineEnd = ("\r\n" if ((Sys.systemName() == "Windows")) else "\n")

RunScript.main()
