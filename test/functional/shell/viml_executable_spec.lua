-- Spec for `executable()`
local helpers = require('test.functional.helpers')(after_each)
local eq, clear, execute, call, os_name =
  helpers.eq, helpers.clear, helpers.execute, helpers.call, helpers.os_name

describe('executable()', function()
  before_each(clear)

  it('returns 1 for commands in $PATH', function()
    if os_name() == 'windows' then
      eq(1, call('executable', 'ping'))
    else
      eq(1, call('executable', 'ls'))
    end
  end)

  it('returns 0 for non existing files', function()
    eq(0, call('executable', 'no_such_file_exists'))
  end)

  describe('in UNIX systems', function()
    if os_name() == 'windows' then
      pending('Windows does not have permissions bits')
      return
    end

    execute('w! test_not_executable')
    call('system', {'chmod', '-x', 'test_not_executable'})
    execute('w! test_executable')
    call('system', {'chmod', '+x', 'test_executable'})

    it('returns 0 for filename or path without the executable bit', function()
      eq(0, call('executable', 'test_not_executable'))
      eq(0, call('executable', './test_not_executable'))
    end)

    it('returns 0 for filename with the executable bit set (not in $PATH)', function()
      eq(0, call('executable', 'test_executable'))
    end)

    it('returns 1 for a path with the executable bit set', function()
      eq(1, call('executable', './test_executable'))
    end)
  end)

  describe('in Windows systems', function()
    if os_name() ~= 'windows' then
      pending('Not Windows')
      return
    end

    local exts = {'bat', 'exe', 'com', 'cmd'}
    setup(function()
      for _,ext in ipairs(exts) do
        execute('w! test_executable_'..ext..'.'..ext)
      end
      execute('w! test_executable_zzz.zzz')
    end)

    teardown(function()
      for _,ext in ipairs(exts) do
        call('delete', 'test_executable_'..ext..'.'..ext)
      end
      call('delete', 'test_executable_zzz.zzz')
    end)

    before_each(function()
      -- No $PATHEXT means .com;.exe;.bat;.cmd
      clear({env={PATHEXT=''}})
    end)

    it('uses fallback $PATHEXT to complete filename', function()
      for _,ext in ipairs(exts) do
        eq(1, call('executable', 'test_executable_'..ext))
      end
      eq(0, call('executable', 'test_executable_zzz'))
    end)

    it('uses fallback $PATHEXT to complete path', function()
      for _,ext in ipairs(exts) do
        eq(1, call('executable', '.\\test_executable_'..ext))
      end
      eq(0, call('executable', '.\\test_executable_zzz'))
    end)

    it('respects $PATHEXT for filenames', function()
      clear({env={PATHEXT='.zzz'}})
      for _,ext in ipairs(exts) do
        eq(0, call('executable', 'test_executable_'..ext))
      end
      eq(1, call('executable', 'test_executable_zzz'))
    end)

    it('respects $PATHEXT for paths', function()
      clear({env={PATHEXT='.zzz'}})
      for _,ext in ipairs(exts) do
        eq(0, call('executable', '.\\test_executable_'..ext))
      end
      eq(1, call('executable', '.\\test_executable_zzz'))
    end)

    it('returns 1 for any existing filename', function()
      for _,ext in ipairs(exts) do
        eq(1, call('executable', 'test_executable_'..ext..'.'..ext))
      end
      eq(1, call('executable', 'test_executable_zzz.zzz'))
    end)

    it('returns 1 for any existing path', function()
      for _,ext in ipairs(exts) do
        eq(1, call('executable', '.\\test_executable_'..ext..'.'..ext))
      end
      eq(1, call('executable', '.\\test_executable_zzz.zzz'))
    end)
  end)
end)
