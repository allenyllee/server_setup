rmdir "%USERPROFILE%\Project" /s /q
mklink /j "%USERPROFILE%\Project" "."

rmdir "%USERPROFILE%\Downloads\WebScrapBook" /s /q
mklink /j "%USERPROFILE%\Downloads\WebScrapBook" ".\repo-book\scrapbook"

rmdir "%USERPROFILE%\Downloads\calibre-books" /s /q
mklink /j "%USERPROFILE%\Downloads\calibre-books" ".\repo-book\calibre-books"

rmdir "%USERPROFILE%\Downloads\books-n-articles" /s /q
mklink /j "%USERPROFILE%\Downloads\books-n-articles" ".\repo-book\books-n-articles"

rmdir "%USERPROFILE%\Downloads\sheet-music" /s /q
mklink /j "%USERPROFILE%\Downloads\sheet-music" ".\repo-book\sheet-music"
