#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Environment
MKDIR=mkdir
CP=cp
CCADMIN=CCadmin
RANLIB=ranlib
CC=gcc.exe
CCC=g++.exe
CXX=g++.exe
FC=
AS=as.exe

# Macros
CND_PLATFORM=MinGW-Windows
CND_CONF=Debug
CND_DISTDIR=dist

# Include project Makefile
include Makefile

# Object Directory
OBJECTDIR=build/${CND_CONF}/${CND_PLATFORM}

# Object Files
OBJECTFILES= \
	${OBJECTDIR}/_ext/_DOTDOT/lib/libxinit.o \
	${OBJECTDIR}/libxio.o

# C Compiler Flags
CFLAGS=

# CC Compiler Flags
CCFLAGS=
CXXFLAGS=

# Fortran Compiler Flags
FFLAGS=

# Assembler Flags
ASFLAGS=

# Link Libraries and Options
LDLIBSOPTIONS=

# Build Targets
.build-conf: ${BUILD_SUBPROJECTS}
	${MAKE}  -f nbproject/Makefile-Debug.mk dist/Debug/MinGW-Windows/liblibxio.dll

dist/Debug/MinGW-Windows/liblibxio.dll: ${OBJECTFILES}
	${MKDIR} -p dist/Debug/MinGW-Windows
	${LINK.c} -shared -o ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/liblibxio.dll ${OBJECTFILES} ${LDLIBSOPTIONS} 

${OBJECTDIR}/_ext/_DOTDOT/lib/libxinit.o: nbproject/Makefile-${CND_CONF}.mk ../lib/libxinit.c 
	${MKDIR} -p ${OBJECTDIR}/_ext/_DOTDOT/lib
	${RM} $@.d
	$(COMPILE.c) -g  -MMD -MP -MF $@.d -o ${OBJECTDIR}/_ext/_DOTDOT/lib/libxinit.o ../lib/libxinit.c

${OBJECTDIR}/libxio.o: nbproject/Makefile-${CND_CONF}.mk libxio.c 
	${MKDIR} -p ${OBJECTDIR}
	${RM} $@.d
	$(COMPILE.c) -g  -MMD -MP -MF $@.d -o ${OBJECTDIR}/libxio.o libxio.c

# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/Debug
	${RM} dist/Debug/MinGW-Windows/liblibxio.dll

# Subprojects
.clean-subprojects:

# Enable dependency checking
.dep.inc: .depcheck-impl

include .dep.inc
