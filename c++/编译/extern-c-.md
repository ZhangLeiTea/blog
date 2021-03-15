https://www.ibm.com/developerworks/cn/aix/library/au-porting/index.html


extern means that the entity has external linkage, i.e. is visible outside its translation unit (C or CPP file). The implication of this is that a corresponding symbol will be placed in the object file, and it will hence also be visible if this object file is made part of a static library. However, extern does not by itself imply that the symbol will also be visible once the object file is made part of a DLL.

__declspec(dllexport) means that the symbol should be exported from a DLL (if it is indeed made part of a DLL). It is used when compiling the code that goes into the DLL.

__declspec(dllimport) means that the symbol will be imported from a DLL. It is used when compiling the code that uses the DLL.

Because the same header file is usually used both when compiling the DLL itself as well as the client code that will use the DLL, it is customary to define a macro that resolves to __declspec(dllexport) when compiling the DLL and __declspec(dllimport) when compiling its client, like so:

``` c++
#if COMPILING_THE_DLL
    #define DLLEXTERN __declspec(dllexport)
#else
    #define DLLEXTERN __declspec(dllimport)
#endif
```

To answer your specific questions:

Yes, extern alone is sufficient for static libraries.
Yes -- and the declaration also needs an extern (see explanation here).
Not quite -- see above.
You don't strictly need the extern with a __declspec(dllimport) (see explanation linked to above), but since you'll usually be using the same header file, you'll already have the extern in there because it's needed when compiling the DLL.