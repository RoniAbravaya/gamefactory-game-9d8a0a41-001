# QA Checklist for Batch-20260107-153932-puzzle-01

## Pre-Testing Setup
- [ ] Install app on test device
- [ ] Clear app data/cache
- [ ] Ensure internet connectivity
- [ ] Test ad network is in test mode

## Menu Screen
- [ ] App launches without crash
- [ ] Game title displays correctly
- [ ] Play button is responsive
- [ ] Settings button is responsive
- [ ] Animations are smooth
- [ ] Sound effects play on button tap

## Gameplay
- [ ] Level 1 loads correctly
- [ ] Player controls are responsive
- [ ] Collision detection works
- [ ] Score increments on collectible pickup
- [ ] Lives decrease on obstacle hit
- [ ] Game pauses correctly
- [ ] Resume from pause works

## Level Progression
- [ ] Level complete screen shows after reaching target score
- [ ] Stars/score display correctly
- [ ] Levels 1-3 are accessible without ads
- [ ] Level 4 shows unlock prompt
- [ ] Rewarded ad displays correctly
- [ ] Level unlocks after ad completion
- [ ] Progress persists after app restart

## Audio
- [ ] Background music plays
- [ ] Sound effects play appropriately
- [ ] Audio toggles work in settings
- [ ] Audio respects device mute

## Performance
- [ ] FPS is stable (60fps target)
- [ ] No memory leaks during extended play
- [ ] No stuttering during gameplay
- [ ] App responds to background/foreground

## Analytics
- [ ] game_start event fires
- [ ] level_start event fires
- [ ] level_complete event fires
- [ ] level_fail event fires
- [ ] unlock_prompt_shown event fires
- [ ] rewarded_ad_* events fire
- [ ] Events appear in Firebase console

## Edge Cases
- [ ] App handles loss of internet
- [ ] App handles ad load failure
- [ ] App handles rapid button taps
- [ ] App handles orientation changes (if applicable)

## Regression
- [ ] All levels playable
- [ ] All UI screens accessible
- [ ] All features from previous builds work

## Sign-off
- Tester: _______________
- Date: _______________
- Version: _______________
- Device: _______________
- OS Version: _______________
