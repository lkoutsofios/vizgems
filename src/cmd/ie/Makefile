:PACKAGE: ast:static

LICENSE		= since=1984,author='dgk+Pat Sullivan'
CCFLAGS		= $(CC.OPTIMIZE) $(CC.DLL)
VERSION		= 1.0

if CC.HOSTTYPE == "linux.i386-64-suse16" || CC.HOSTTYPE == "linux.i386-64-suse90" || CC.HOSTTYPE == "linux.i386-64-suse99" || CC.HOSTTYPE == "linux.i386-64-arch99"
CCFLAGS += --std=c99
end

ESH		== 1
VSH		== 1
LDYNAMIC	== 1

edit $(VERSION) :LIBRARY: editlib.c vi.c emacs.c history.c edit.c +ldll

ie :: ie.sh

:: PROMO.mm RELEASE
