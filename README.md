# evolvable sound

this program uses humans and sounds to evolve music

### raspberry pi setup

```
sudo gem install bundler --no-rdoc --no-ri
git clone https://github.com/mattruzicka/evolvable_sound.git
cd evolvable_sound
sudo bundle install
amixer cset numid=3 1
sudo apt-get install ttf-ancient-fonts
```
