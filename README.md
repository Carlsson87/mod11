# Mod11

Modulus 11 can be implemented in different ways. This implementation is made according to the description in [this document](https://www.bankgirot.se/globalassets/dokument/anvandarmanualer/11-modul.pdf) (english description starts on page 4).

Modulus 11 is method to calculate a check digit. Check digits helps detect human transcription errors, for example in bank account numbers. More about check digits can be read [here](https://en.wikipedia.org/wiki/Check_digit).


## Usage
```elm
import Mod11

Mod11.calculate "24135" == Just '0'
Mod11.verify "241350" == True
```
