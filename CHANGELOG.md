The newest version just released evening of 20/06/21 has the following changes:

- Dialog adjusted with hints added and parts rephrased based on player feedback
- Removed old and unused scenes to get the exported file below 300mb for webassembly compatibility on mobile. (Attempted to build export templates without a bunch of stuff, but didn't really file size).
- Resized waterfall textures to half size for the above reason.
- Possible fix for Dialog textbox clipping
- Fixed IOS bug where the joystick freezes on reappearance during the tutorial inspection of rock
- Fixed intro animation fast forward tocuh
- Put torches back onto the model (two floorfacing)
- Reduced noise and upped brightness in camera images for mobile
- Fixed whisker detection of iniital rock by modifying shape of whiskers
- Tutorial waterfall is now a bit further forward with my obvious dialog cues to go through
- Tutorial mesh behind waterfall now extends further
- Mission_1 now places player in front of waterfall for continuity
- Flower hints after analysis are now disabled to avoid flooding user with hints.
- Dialog now makes clear that flowers are side objective
- Made some of the vine walls invisible as players complaining of getting extremely disorientated
- Cave paintings added and triggers attached during second half of mission_1
- Ambient audio added for tutorial level, and waterfall now has audio
- 3D waterfall audio included in mission. Mission also includes a number of audio cues including fire and - an electronic beeping emanating from the robot.
- Updated Credits to include audio credits.
- Taking high res pictures now adds pictures to journal

## Known Issues:

- Something wacky is still going on with the fauna mission, needs further investigation.
- Probably needs more specific audio, I've just used the main menu background audio multiple times.
- Robot can get stuck on low rocks, not great especially in the dark. (Robot probably needs to have more ground clearance)