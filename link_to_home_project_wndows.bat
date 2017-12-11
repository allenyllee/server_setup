rmdir "%USERPROFILE%\Project" /s /q
mklink /j "%USERPROFILE%\Project" "."

rmdir "%USERPROFILE%\Downloads\WebScrapBook" /s /q
mklink /j "%USERPROFILE%\Downloads\WebScrapBook" ".\repo-book\scrapbook"