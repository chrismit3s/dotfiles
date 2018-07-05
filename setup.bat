@echo off

set files=(cvimrc, gitconfig, vsvimrc)
set source=D:\Chrissidtmeier\Dotfiles
set dest=C:\Users\Chrissidtmeier

for %%f in %files% do (
	copy %source%\%%f %dest%\.%%f
)