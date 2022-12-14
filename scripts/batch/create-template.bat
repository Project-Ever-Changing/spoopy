::Idk if I did this right...

@echo off

SET PROJECT_DIR="%cd%"
SET DOCS_FILE="../../docs/spoopy-project-dir.txt"

echo %PROJECT_DIR% >> %DOCS_FILE%