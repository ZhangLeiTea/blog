

1. CMAKE_FIND_LIBRARY_SUFFIXES

   - This specifies what suffixes to add to library names when the find_library() command looks for libraries. On Windows systems this is typically .lib and .dll, meaning that when trying to find the foo library it will look for foo.dll etc

1. CMAKE_FIND_LIBRARY_PREFIXES

   - This specifies what prefixes to add to library names when the find_library() command looks for libraries. On UNIX systems this is typically lib, meaning that when trying to find the foo library it will look for libfoo.