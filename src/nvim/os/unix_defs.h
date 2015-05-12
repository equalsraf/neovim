#ifndef NVIM_OS_UNIX_DEFS_H
#define NVIM_OS_UNIX_DEFS_H

#include <unistd.h>
#include <signal.h>

// Defines BSD, if it's a BSD system.
#ifdef HAVE_SYS_PARAM_H
# include <sys/param.h>
#endif

#define BASENAMELEN (MAXNAMLEN - 5)

#define TEMP_DIR_NAMES {"$TMPDIR", "/tmp", ".", "~"}
#define TEMP_FILE_PATH_MAXLEN 256

#define HAVE_ACL (HAVE_POSIX_ACL || HAVE_SOLARIS_ACL)

// Special wildcards that need to be handled by the shell.
#define SPECIAL_WILDCHAR "`'{"

// Separator char for environment variables
#define ENV_SEPCHAR ':'

#endif  // NVIM_OS_UNIX_DEFS_H
