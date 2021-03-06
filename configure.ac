# libtool version: current:revision:age
#
# If the library source code has changed at all since the last update, then
# increment revision (`c:r:a' becomes `c:r+1:a').
#
# If any interfaces have been added, removed, or changed since the last update,
# increment current, and set revision to 0.
#
# If any interfaces have been added since the last public release, then
# increment age.
#
# If any interfaces have been removed since the last public release, then set
# age to 0.
#
# In summary:
#
#  If any interface has been changed or removed, `c:r:a' becomes `c+1:0:0';
#  else if any interface has been added, `c:r:a' becomes `c+1:0:a+1';
#  else, `c:r:a' becomes `c:r+1:a'.
#
m4_define([comedilib_lt_current], [11])
m4_define([comedilib_lt_revision], [0])
m4_define([comedilib_lt_age], [11])
# Set 'letter', normally empty.  See below for rules.
m4_define([comedilib_version_letter], [a])

#libscxi c:r:a
m4_define([scxi_lt_current], [9])
m4_define([scxi_lt_revision], [0])
m4_define([scxi_lt_age], [9])

# comedilib library version: major.minor.micro
# comedilib package version: major.minor.micro[letter]
#
# Currently:
#  * 'major' may be incremented at the whim of the maintainers.
#  * 'minor' is libtool 'current' minus the value of 'current' when major
#    changed (comedilib_major_base_current).
#  * 'micro' is libtool 'revision'.
#  * 'letter' is normally absent and is removed if any of 'major', 'minor'
#    or 'micro' are changed between releases.  Otherwise it is set if the
#    only changes between releases are outside the library source code or
#    language binding, for example the comedilib manual, "readme" files
#    or sample configuration files.  When it needs to be set, it is set to
#    'a' if previously absent, otherwise the next lower-case ASCII letter
#    in the sequence.  (In the unlikely event that we we need to go beyond
#    'z', append an extra letter.)
#
# Example package version sequence: 0.10.1, 0.10.1a, 0.10.1b, 0.10.2,
# 0.10.2a, ..., 0.10.2z, 0.10.2za, 0,10.2zb, 0.11.0.

# Gentle reminder: The comedilib manual mentions the version of comedilib
# it applies to.  This is done by setting the 'comedilib_version' entity
# in "doc/comedilib.ent".  That needs to be edited manually as it is not
# updated automatically.  Policy: the version of the manual is usually only
# updated if the contents have changed since the previous release.  In that
# case, it is set to the comedilib package version.

# Manually set 'comedilib_major_base_current' to new 'comedilib_lt_current'
# whenever 'comedilib_version_major' is incremented below.
m4_define([comedilib_major_base_current], [0])

m4_define([comedilib_version_major], [0])
m4_define([comedilib_version_minor],
	  [m4_eval(comedilib_lt_current - comedilib_major_base_current)])
m4_define([comedilib_version_micro], [comedilib_lt_revision])
m4_define([comedilib_pkg_version],
	  [m4_join([],
		   m4_join([.], comedilib_version_major,
			   comedilib_version_minor,
			   comedilib_version_micro),
		   comedilib_version_letter)])

AC_INIT([comedilib], [comedilib_pkg_version])
AC_CANONICAL_TARGET([])

COMEDILIB_VERSION_MAJOR=comedilib_version_major
COMEDILIB_VERSION_MINOR=comedilib_version_minor
COMEDILIB_VERSION_MICRO=comedilib_version_micro
AC_SUBST(COMEDILIB_VERSION_MAJOR)
AC_SUBST(COMEDILIB_VERSION_MINOR)
AC_SUBST(COMEDILIB_VERSION_MICRO)

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([.])
#COMEDILIB_DEBUG="-Wall -Werror"
COMEDILIB_DEBUG="-Wall"
AM_INIT_AUTOMAKE([-Wall -Werror])

AC_CONFIG_HEADERS([config.h])

ACLOCAL="$ACLOCAL -I m4"

AM_MAINTAINER_MODE([enable])

AM_PROG_AR
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CC_STDC
AC_ISC_POSIX
AM_PROG_LEX
AC_PROG_YACC
AC_PROG_LIBTOOL
AC_PROG_MKDIR_P

AC_HEADER_STDC([])

AX_TLS

# AS_LIBTOOL arguments are (prefix, current, revision, age)
AS_LIBTOOL(COMEDILIB, comedilib_lt_current, comedilib_lt_revision, comedilib_lt_age)
SCXI_SO_VERSION=scxi_lt_current:scxi_lt_revision:scxi_lt_age
AC_SUBST(SCXI_SO_VERSION)

COMEDILIB_CFLAGS="$COMEDILIB_CFLAGS -I\$(top_srcdir)/include -I\$(top_builddir)/include $COMEDILIB_DEBUG"
COMEDILIB_LIBS="$COMEDILIB_LIBS \$(top_builddir)/lib/libcomedi.la -lm"
AC_SUBST(COMEDILIB_CFLAGS)
AC_SUBST(COMEDILIB_LIBS)

# autoconf backwards compatibility
if test "$datarootdir" = ""; then
	datarootdir='${datadir}'
	AC_SUBST(datarootdir)
fi

if test "$docdir" = ""; then
	docdir='${datarootdir}/doc/${PACKAGE}'
	AC_SUBST(docdir)
fi

if test "$htmldir" = ""; then
	htmldir='${docdir}'
	AC_SUBST(htmldir)
fi

if test "$pdfdir" = ""; then
	pdfdir='${docdir}'
	AC_SUBST(pdfdir)
fi

#swig
AC_PATH_PROG(SWIG, swig, "no")
if test "$SWIG" == "no" ; then
	AC_MSG_WARN([swig not found, will not be able to build swig based bindings])
fi

#python
AC_ARG_ENABLE([python-binding],
	[AS_HELP_STRING([--disable-python-binding],
		[Disable building of Python binding])],
	[ENABLE_PYTHON=$enableval],[ENABLE_PYTHON="yes"])
if test "$ENABLE_PYTHON" == "yes" && test "$SWIG" != "no"; then
	AM_PATH_PYTHON
	AM_CHECK_PYTHON_HEADERS(HAVE_PYTHON=yes,[HAVE_PYTHON=no;AC_MSG_WARN([python headers not found, disabling python binding])])
else
	HAVE_PYTHON="no"
fi
AM_CONDITIONAL(HAVE_PYTHON, [test "$HAVE_PYTHON" == "yes" && test "$ENABLE_PYTHON" == "yes"])

AS_COMPILER_FLAG([-fno-strict-aliasing],[PYTHON_QUIET="$PYTHON_QUIET -fno-strict-aliasing"], true )
AS_COMPILER_FLAG([-Wno-unused-function],[PYTHON_QUIET="$PYTHON_QUIET -Wno-unused-function"], true )
AC_SUBST(PYTHON_QUIET)

# ruby
AC_ARG_ENABLE([ruby-binding],
	[AS_HELP_STRING([--enable-ruby-binding],
		[Enable building of Ruby binding])],
	[ENABLE_RUBY=$enableval], [ENABLE_RUBY="no"])
if test "$ENABLE_RUBY" == "yes" && test "$SWIG" != "no"; then
	AC_PATH_PROG(RUBY, ruby, no)
	if test "$RUBY" != "no" ; then
		RUBY_INC_DIR=`$RUBY -e "require 'rbconfig'; c = ::Config::CONFIG; print c[['archdir']];"`
		AC_CHECK_HEADER([$RUBY_INC_DIR/ruby.h],[],[ENABLE_RUBY="no";AC_MSG_WARN([ruby.h not found, disabling Ruby binding])])
	else
		AC_MSG_WARN([ruby not found, disabling ruby binding])
		ENABLE_RUBY="no"
	fi
else
	ENABLE_RUBY="no"
fi

AM_CONDITIONAL(HAVE_RUBY, [test "$ENABLE_RUBY" == "yes"])

AC_ARG_VAR(RUBY_PREFIX,[path prefix for Ruby binding])
AC_ARG_VAR(RUBY_SO_DIR,[path for Ruby extensions])
if test "$RUBY_PREFIX" != "" ; then
	RUBY_CONFIG_OPTIONS="$RUBY_CONFIG_OPTIONS --prefix=\$(RUBY_PREFIX)"
fi
if test "$RUBY_SO_DIR" != "" ; then
	RUBY_CONFIG_OPTIONS="$RUBY_CONFIG_OPTIONS --so-dir=\$(RUBY_SO_DIR)"
fi
AC_SUBST(RUBY_CONFIG_OPTIONS)

# scxi
AC_ARG_ENABLE([scxi],
	[AS_HELP_STRING([--enable-scxi], [Enable SCXI convenience library])],
	[ENABLE_SCXI=$enableval], [ENABLE_SCXI="no"])
AM_CONDITIONAL(BUILD_SCXI, [test "$ENABLE_SCXI" == "yes"])

# docbook
AC_ARG_ENABLE([docbook],
	[AS_HELP_STRING([--disable-docbook], [Disable docbook])],
	[ENABLE_DOCBOOK=$enableval],[ENABLE_DOCBOOK="yes"])

if test "$ENABLE_DOCBOOK" == "yes"; then
	AC_PATH_PROG(XMLTO, xmlto, no)
	if test "$XMLTO" = "no" ; then
  		AC_MSG_WARN([xmlto not found, will not be able to rebuild documentation])
	fi
else
	XMLTO="no"
fi

if test "$XMLTO" != "no"; then
	AC_ARG_WITH([pdf-backend],
		[AS_HELP_STRING([--with-pdf-backend=[[yes|no|dblatex|fop|default]]],
			[Enable or disable PDF generation with backend])],
		[WITH_PDF_BACKEND=$withval],[WITH_PDF_BACKEND="yes"])
	case "$WITH_PDF_BACKEND" in
	no)
		PDF_BACKEND="no"
		;;
	yes)
		# Prefer dblatex, then default backend.
		# Could use [dblatex fop] to prefer dblatex or fop.
		AC_CHECK_PROGS([PDF_BACKEND], [dblatex], [default])
		# The default backend is broken, so avoid it for now.
		if test "$PDF_BACKEND" = "default"; then
			AC_MSG_WARN([Default PDF backend is broken, disabling PDF generation])
			AC_MSG_WARN([(dblatex is recommended for PDF generation)])
			PDF_BACKEND="no"
		fi
		if test "$PDF_BACKEND" != "no"; then
			AC_MSG_NOTICE([Will use $PDF_BACKEND backend for PDF generation])
		fi
		;;
	default)
		# Use xmlto's default backend.
		PDF_BACKEND="default"
		;;
	dblatex|fop)
		AC_CHECK_PROG([PDF_BACKEND], [$WITH_PDF_BACKEND],
			[$WITH_PDF_BACKEND], [no])
		if test "$PDF_BACKEND" = "no"; then
			AC_MSG_WARN([$WITH_PDF_BACKEND not found, disabling PDF generation])
		fi
		;;
	*)
		AC_MSG_WARN([Bad --with-pdf-backend option, disabling PDF generation])
		PDF_BACKEND="no"
		;;
	esac
else
	PDF_BACKEND="no"
fi
case $PDF_BACKEND in
fop|default)
	AC_MSG_WARN([$PDF_BACKEND PDF backend might not work.  --without-pdf-backend disables PDF generation.])
	;;
esac
AM_CONDITIONAL(HAVE_XMLTO, [test "$XMLTO" != "no"])
AM_CONDITIONAL(BUILD_PDF, [test "$PDF_BACKEND" != "no"])
AM_CONDITIONAL(BUILD_PDF_USING_DBLATEX, [test "$PDF_BACKEND" = "dblatex"])
AM_CONDITIONAL(BUILD_PDF_USING_FOP, [test "$PDF_BACKEND" = "fop"])

pcmciadir="\${sysconfdir}/pcmcia"
AC_SUBST(pcmciadir)

# firmware
AC_ARG_ENABLE([firmware],
	[AS_HELP_STRING([--disable-firmware], [Disable installation of firmware files])],
	[ENABLE_FIRMWARE=$enableval],[ENABLE_FIRMWARE="yes"])

# new udev hotplug
AC_ARG_WITH([udev-hotplug],
	[AS_HELP_STRING([--with-udev-hotplug=[[/lib]]], [enable udev hotplug])],
	[ENABLE_UDEVHOTPLUG=$withval], [ENABLE_UDEVHOTPLUG="no"])
AM_CONDITIONAL(INSTALL_UDEVHOTPLUG, [test "$ENABLE_UDEVHOTPLUG" != "no"])
if test "$ENABLE_UDEVHOTPLUG" != "no"; then
	if  test "$ENABLE_UDEVHOTPLUG" == "yes"; then
		AC_MSG_ERROR([udev-hotplug needs a path as an argument (usually: --enable-udev-hotplug=/lib).])
	fi
	if test "$ENABLE_UDEVHOTPLUG" != "/lib"; then
		AC_MSG_WARN([Installing the udev scripts in the non-standard location: $ENABLE_UDEVHOTPLUG (should be --enable-udev-hotplug=/lib)])
	fi
	udevrulesdir="$ENABLE_UDEVHOTPLUG/udev/rules.d/"
	udevscriptsdir="$ENABLE_UDEVHOTPLUG/udev"
	AC_SUBST(udevrulesdir)
	AC_SUBST(udevscriptsdir)
	if test "$ENABLE_FIRMWARE" == "yes"; then
	udevfirmwaredir="$ENABLE_UDEVHOTPLUG/firmware"
	AC_SUBST(udevfirmwaredir)
	fi
else
	ENABLE_UDEVHOTPLUG="no"
fi

if test "$ENABLE_UDEVHOTPLUG" = "no" ; then
		AC_MSG_WARN([No hotplug mechanism will be installed. Consult ./configure --help if you want hotplug.])
fi

AC_CONFIG_FILES(
Makefile
comedi_config/Makefile
comedi_board_info/Makefile
c++/Makefile
c++/include/Makefile
etc/Makefile
etc/pcmcia/Makefile
etc/hotplug/Makefile
etc/hotplug/usb/Makefile
etc/hotplug/usb/usbdux/Makefile
etc/hotplug/usb/usbduxfast/Makefile
etc/hotplug/usb/usbduxsigma/Makefile
etc/udev/Makefile
doc/Makefile
demo/Makefile
include/Makefile
include/comedilib_version.h
lib/Makefile
man/Makefile
scxi/Makefile
swig/Makefile
swig/python/Makefile
swig/ruby/Makefile
testing/Makefile
comedilib.spec
comedilib.pc
)

AC_OUTPUT
