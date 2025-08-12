@echo off
:: This script automatically builds and deploys the Hugo blog.

title Hugo Blog Auto-Publish

echo.
echo =================================
echo  Hugo Blog Auto-Publish Script
echo =================================
echo.


echo [1/4] Adding all changes to git...
git add .
echo      'git add' complete!
echo.

echo [2/4] Committing changes...
git commit -m "update blog"
echo      Commit successful!
echo.

echo [3/4] Pushing to remote repository (github master)...
git push -u github master
if %errorlevel% neq 0 (
    echo.
    echo !!! ERROR: Git push failed. Please check network or permissions.
    pause
    exit /b
)
echo      Push successful!
echo.

echo [4/4] All done! Your site has been published successfully.
echo.
echo =================================
echo.

pause
