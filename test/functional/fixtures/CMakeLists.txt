if(NOT WIN32)
  add_executable(tty-test tty-test.c)
  target_link_libraries(tty-test ${LIBUV_LIBRARIES})
endif()

add_executable(shell-test shell-test.c)
