#!/bin/sh

RED="\033[1;31m"
NOCOLOR="\033[0m"

BOLD=`tput bold`
REGULAR=`tput rmso`

echo "${RED} @@@@@@   @@@@@@@    @@@@@@    @@@@@@   @@@@@@@   @@@ @@@  ${NOCOLOR}"
echo "${RED}@@@@@@@   @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@ @@@  ${NOCOLOR}"
echo "${RED}!@@       @@!  @@@  @@!  @@@  @@!  @@@  @@!  @@@  @@! !@@  ${NOCOLOR}"
echo "${RED}!@!       !@!  @!@  !@!  @!@  !@!  @!@  !@!  @!@  !@! @!!  ${NOCOLOR}"
echo "${RED}!!@@!!    @!@@!@!   @!@  !@!  @!@  !@!  @!@@!@!    !@!@!   ${NOCOLOR}"
echo "${RED} !!@!!!   !!@!!!    !@!  !!!  !@!  !!!  !!@!!!      @!!!   ${NOCOLOR}"
echo "${RED}     !:!  !!:       !!:  !!!  !!:  !!!  !!:         !!:    ${NOCOLOR}"
echo "${RED}    !:!   :!:       :!:  !:!  :!:  !:!  :!:         :!:    ${NOCOLOR}"
echo "${RED}:::: ::    ::       ::::: ::  ::::: ::   ::          ::    ${NOCOLOR}"
echo "${RED}:: : :     :         : :  :    : :  :    :           :     ${NOCOLOR}"
echo ""
echo "${BOLD}SpoopyEngine Command-Line Tools"
echo ""
echo "${REGULAR}Basic Commands: "
echo ""
echo "  build : Compile necessary requirements to use Spoopy Engine."
echo "  create : Create a new project from a template."
echo "  setup : Setup spoopy library."
echo "  destroy : Destroy necessary requirements."
echo "  update : Finds any updates available."
echo "  ls : Get long list from directory inside the library."
echo "  test : Update, build, and run in one command line."