
### Compatibility patch for clang\_complete

Both clang\_complete and neocomplcache uses completefunc. This patch resets
completefunc for clang\_complete whenever code completion is invoked.

```
; neocomplcache configuration
let g:neocomplcache_force_overwrite_completefunc=1
```

This makes clang\_complete and neocomplcache set completefunc back and forth.

