ATENTION!

Complete rewrite!

# xmonad
What is Xmonad? It is a tiling window manager that is notoriously minimal, stable, beautiful, and featureful. If you find yourself spending a lot of time organizing or managing windows, you may consider trying xmonad. Xmonad can be somewhat difficult to configure if you're new to Haskell or even to Xmonad itself. This project contains a completely working and very usable xmonad configuration "out of the box". If you are just starting out with Xmonad, this will give you a configuration that I personally use for around 8 hours every day. Thought has been put into the colors, key bindings, layouts, and supplementary scripts to make life easier. This config fit with xmonad ver 12. 

All Xmonad configuration is in ~/.xmonad/xmonad.hs. This includes things like key bindings, colors, layouts, etc. You may need to have some basic understanding of Haskell in order to modify this file, but most people have no problems. Configuration file for xmobar is in ~/.xmonad. Xmobar is configured to show date and time, cpu usage, cpu temp, disk usage (root dir), disk activity, current keyboard layout and volume with nice bars (separate script).

All scripts are in ~/.scripts. Scripts are provided to do things like take screenshots, (i use scrot, slop and viewnior) , mpd status in xmobar (gets the currently playing song from MPD) . Also i included scripts for capturing videos of your dektop (in .utility folder). So you don't need any external program. You just need ffmpeg and mkv codec, mostly autoinstalled when You have a multimedia player like Smplayer. To use this, just launch the sript `record`.

The video will be saved in ~/Videos/record.mkv. Rename it first before take another recording session 😉
To stop recording, just navigate to script `stop-recording` and launch it.

P.S.

My font is Liberation Mono. Also check these [Nerd-Fonts](https://github.com/ryanoasis/nerd-fonts) and get acquainted with the details.  It have 40+ patched fonts, over 3,600 glyph/icons, includes popular collections such as Font Awesome & fonts such as Hack. Worth to try it!

My shell is zsh with [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) framework.

Also, i put configs for ranger fm (with trash support, package  [trash-cli](https://github.com/andreafrancia/trash-cli#can-i-alias-rm-to-trash-put) is needed), mpd, ncmpcpp (a simple ncmpcpp config, with album art support. To use ncmpcpp with album art, simply launch ncmpcpp -c /home/yourusername/.config/ncmpcpp/config-art-dark. Urxvt with pixbuf enabled is needed. Also integrated with dunst notification. Just copy my dunst config, install dunst, and do nothing. Dunst will launch automatically if triggered by notify-send event) and xresources. I put the colour configuration in ~/.xrdb folder and include it in Xresources using #include command. It makes me able to change or mix the colour scheme for urxvt and rofi easily. You will understand if you look at it. All of my favourite terminal colour scheme i frequently use on my setup is available in ~/.xrdb/color folder), scrot+viewnior (a simple script to take screenshoot using scrot, then add date to the file name, then open the result instantly using Viewnior), slop+script (make screenshot of selected area), rofi (rofi colour is set in ~/.Xresources, but it just an #INCLUDE command. The actual colour configuration is in ~/.xrdb/rofi. You will understand if you look at it. 


In this repo you will find Gtk2/3 themes (Fantome, Lumiere, Noita, Ocha, Tee, Vestica, Charma-Nightingale, Charma-Ype, Forest-Dark, Forest-Darker and Forest-Light) and icons (Arc, Canta, ePapirus, Numix, Numix-Circle, Numix-Circle-Light, Numix-Light, Papirus, Papirus-Adapta, Papirus-Adapta-Nokto, Papirus-Dark and Papirus-Light). These themes and icons are very relevant to the overall picture.

Screenshots

![Screenshot](screen.png?raw=true "Clear")
![Screenshot](screen_1.png?raw=true "Notification")
![Screenshot](screen_2.png?raw=true "Rofi")
![Screenshot](screen_3.png?raw=true "Binclock")
![Screenshot](screen_4.png?raw=true "Binclock")
![Screenshot](screen_5.png?raw=true "Cat")
![Screenshot](screen_6.png?raw=true "Cat")
![Screenshot](screen_7.png?raw=true "Cat")

![Please do not theme this app](https://stopthemingmy.app/badge.svg)

                                                   LICENSE
                                                    
                                                    
                                                    
     

 > This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

   > This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   > You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/
                                   
                                   
                                             AUTHOR
                                              
- Mindaugas Celiešius (m.celiesius@yandex.ru)                                              
