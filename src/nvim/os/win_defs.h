#ifndef NVIM_OS_WIN_DEFS_H
#define NVIM_OS_WIN_DEFS_H

// winsock2.h must be before windows.h - or so says Mingw
#include <winsock2.h>
#include <windows.h>
#include <sys/stat.h>
#include <io.h>
#include <uv.h>
#include <stdio.h>
#include <time.h>
#include "auto/config.h"

#ifndef LC_MESSAGES
// FIXME(equalsraf): this is a hack - also used in ex_cmds2.c to build in
// windows without libintl
# define LC_MESSAGES LC_COLLATE
#endif

#define FNAME_ILLEGAL "\"*?><|"

#define USE_CRNL

// We have our own RGB macro in macros.h
#undef RGB

// For MSVC
#ifdef _MSC_VER
# ifndef inline
#  define inline __inline
# endif
# ifndef restrict
#  define restrict __restrict
# endif
# ifndef S_IXUSR
#  define S_IXUSR S_IEXEC
# endif
# ifndef __func__
#  define __func__ __FUNCTION__
# endif
# ifndef STDOUT_FILENO
#  define STDOUT_FILENO _fileno(stdout)
# endif
# ifndef STDERR_FILENO
#  define STDERR_FILENO _fileno(stderr)
# endif
#endif // _MSC_VER

#define TEMP_DIR_NAMES {"$TMP", "$TEMP", "$USERPROFILE", ""}
#define TEMP_FILE_PATH_MAXLEN _MAX_PATH

#ifndef BASENAMELEN
# define BASENAMELEN  (_MAX_PATH - 5)
#endif

#ifdef _MSC_VER
typedef SSIZE_T ssize_t;
#endif

#ifndef SSIZE_MAX
# ifdef _WIN64
#  define SSIZE_MAX _I64_MAX
# else
#  define SSIZE_MAX LONG_MAX
# endif
#endif

typedef uv_uid_t uid_t;

#endif  // NVIM_OS_WIN_DEFS_H
