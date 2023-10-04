## Enable DND button on M2 Mac

* download karabiner-elements: https://karabiner-elements.pqrs.org/
* set f6 to f15 (https://github.com/pqrs-org/Karabiner-Elements/issues/2516#issuecomment-753877943)
* open keyboard shortcuts and set DND to your f6 (f15) key
* if f15 already assigned to screen brightness just uncheck that box since screen brightness is already controlled by f1/f2

## Show hidden files in finder by default

```
defaults write com.apple.finder AppleShowAllFiles -boolean true; killall Finder;
```
