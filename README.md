# swiftui-capsule-picker
![CapsulePicker_AdobeExpress](https://github.com/poromaa/swiftui-capsule-picker/assets/5236460/71efdbb6-c890-4ac8-9950-ec31a52ad5d0)

This was created based on this Stack overflow-thread. 
Customizable Picker that imitate Apple original in feel.

https://stackoverflow.com/questions/60804512/swiftui-create-a-custom-segmented-control-also-in-a-scrollview#new-answer
No solution had really the feel of the original Picker. Made some improvements such as
- detect on-press/release that toggle isDragging (to allow capsule to animate size)
- possiblility to drag over several options and then release and see updates
- well. just try it if it helps.

To bee seen as a starting point. Intentially kept the code as easy as possible (uses array of titles [String] instead of views so no support for icons etc).

