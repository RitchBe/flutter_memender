import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';




Map deletedFlush = {
  'Meme deleted 😿' : '..little bird gone too early 🐤 ',
  'Would rather change a baby diaper.. 👶':'..than looking at this meme again 🍼',
  'This one get you mad 😠': 'I like that 😈',
  'Deleting this one was a nice move for the community 🌍': 'Thank you 🙏',
  '3...2...1 😵' : 'FATALITY 💀 => ⚰️',
  'You got served 🤸' : ' Looser 🚶',
   'I feel you 😿' : 'Do you need a shoulder to cry on? 🎻',
   'Booouuuhhhh 😾' : 'Just go home you miserable piece of not entertaining meme 🤚',
   'Trump would put a wall in front of that one too': '🚧 🚧 🚧',
   "Random Fact: 👨‍🎓": "Don't meet people from the internet 🙅‍",
   'Upgrade your humour for the next one 😑' : 'I mean really 😑',
   "Don't ever polluate my database again" : '👿👿👿',
   "You little bastard don't give any fuck 👹" : "Don't you ? 👹",
   'Mark Zuckerberg would not agree either 👽' : 'No one would 🙅‍',
   'Shown this one to my grandmother 👵': 'She did not get it 🤦‍♂️',
   "Even my son didn't find it funny 🧒" : 'And he is pretty dumb 🧒',
   'Some people are funny.. 🤔': '..others are just nice 👁️',
   'It does belong in the bin 🗑️':'Not sure why it was here in the first place 🤷',
   'How come it pass the security check ?? 👮👮' : 'Must have been white.. 🕵️🕵️',
   'Please.. 🙏' : "MAKE MEME GREAT AGAIN 🙏",
   'Little piece of shit meme 👿': 'get the fuck out of here 🚪',
   'Yoooo Bitch, get out the way 🎶' :' Get out the way bitch ,get out the way 🎶',
   'That one is going straight to the looser gang': '🚶🚶🚶',
   'Doest it deserve to go to the Valhalla? 🔨🤔':'Probably not.. ⛔',
   'I will put it my self to the graveyard 💐 ⚰️' : 'Gotta loved them all a little bit.. 💕💕💕'
};

Map favoriteFlush = {
  'Adding to favorite..' : 'Your gallery will look better with this addition 📸🖼️',
  'Adding to favorite...': ' Take your socks out in bed 🧦 Advise from a friend 👨‍🏫',
  'Adding to favorite' : 'Even that one would have made Kayne laugh 😹',
  'Adding to favorite 😎' : 'Stop procastinating... 👁️👁️ ..just kidding 👀',
  "Random Fact: I hope when I die it's early in the morning ☠️": "I don't want to go to work for no reason 🤷 ",
  "Adding to favorite..😎" : "Aunti Marta would agree too 👵 And she doesn't even have a sense of humour 👵",
  "Adding to favorite 🤖" : "You like that one, hun!! 😏😏😏",
  "Adding to favorite..🤖" : "My mom liked that one too ! You should share it with yours 🤱",
  "Adding to favorite... 🤖" :" This one made me cry 😹 Not even kidding 🐈",
  "Adding to favorite👾": " That one felt like a shot of Tequila 🍸 I am not even alcoholic 🥂",
  "Adding to favorite..👾" : "This one belong in the Hall Of Fame of meme #1🏆🏆",
  "Adding to favorite...👾" : "Why don't you go in the street 🏙️And scream this one is good? 🕺",
  "Adding to favorite 👑" : 'You should made a tshirt of it 👕 At least some socks 🧦',
  "Adding to favorite..👑" :'Your twitter fanbase will appreciate it🐦🐦',
  "Adding to favorite...👑" : "Should you send it to your crush ? 😏",
  "Adding to favorite 🐈":"You should create a sect around this meme 🕯️ Or maybe a Cult? 🧛",
  "Adding to favorite..🐈": 'This one should be in the bible or something📕',
  "Adding to favorite... 🐈": "Let's start a petition to get this meme on google landing page ✒️📜",
  "Adding to favorite🦄": "Let's start a petition to get this one at the Louvre✒ ️📜",
  "Adding to favorite..🦄" : 'Could you send it to Banksy? 🕊️',
  "Adding to favorite...🦄": 'How much do you think it cost to have it on Time square ?🗽',
  "Adding to favorite 🐒":"Did you share it to your only two friends? 🐿️ I feel you.. 🎻",
  "Adding to favorite..🐒" : "..Send it to your crush 😏 If you want to get some..😏 ",
  "Adding to favorite...🐒":"You should make an expose on this one 👨‍🎓",
  "Adding to favorite 🚀" : "Good job lil Amstrong 👩‍🚀 It's going straight to the stratosphere 🚀"

};

Map shareFlush = {
  "Why don't you go in the street 🏙️" : "And scream this one is good? 🕺",
  "You should made a tshit of it 👕" : 'At least some socks 🧦',
  "Your twitter fanbase will appreciate it" :'🐦🐦',
  "Don't be shy, you didn't even send it your crush" : "Should you ? 😏",
  "You should create a sect around this meme 🕯️":"Or maybe a Cult? 🧛",
  "This one should be in the bible or something": '📕',
  "Let's start a petition to get this meme on google landing page": '✒️📜',
  "Let's start a petition to get this one at the Louvre": '✒️📜',
  "Could you send it to Banksy? 🕊️" : 'Never know 🤷',
  "How much do you think it cost to have it on Time square ?": '🗽',
  "Did you share it to your only two friends? 🐿️":"I feel you.. 🎻",
  "If you want to get some..😏" : "..Send it to your crush 😏",
  "Are you still at school? 👨‍🎓":"You should make an expose on this one 👨‍🎓",
  "This one is going straight to the stratosphere 🚀" : "Good job lil Amstrong 👩‍🚀"

};

Map addFlush = {
  "Make sure it's a good one ! 😈" : "You little rascal 🧒",
  "How long did it get you to make this one? ⏱️" : "Better be good 😈",
  "MEME IS NOT A CRIME": '..keep the art alive 🎨',
  "My wife asked me to stop singing under the shower🎤🚿":"Three times this week. And it's only Monday 🤷",
  "I really appreciate your effort 👍" :"*tap on the shoulder* *whisper in your ear* Friends 🤫",
  "Thank you 🙏":"Now the pain is over 😻 ",
  "Thank you 🙏":"..for feeling my emptiness 🕳️",
  "Damnn.. 💡": "...I knew I was missing something 🔎",
  "We are all sick 🤒": "Your meme might be the therapy 💊💊"

};