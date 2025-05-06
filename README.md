# barber_time

A new Flutter project.

## Getting Started

# context.push(RoutePath.signInScreen); // new Screen Navigation

# context.go(RoutePath.signInScreen); // befor all route remove

# context.pushNamed(RoutePath.signInScreen); new screen best prectice

# context.pop(); ...// that means back button

# context.replace(RoutePath.signInScreen);

# and  context.replaceNamed(RoutePath.signInScreen);//এটি বর্তমান স্ক্রিন remove করে নতুন স্ক্রিন লোড করে।

# that means jei screen ta te thakbo sei screen ta muse ager screen e jabe


*/যদি ব্যাক বাটন প্রেস করার আগে চেক করতে চান, যে ব্যাক নেওয়া সম্ভব কিনা।
if (context.canPop()) {
context.pop();
} else {
debugPrint("==========================No back screen available");
}
/*

# context.pushReplacement(RoutePath.signInScreen); // remove before 1 screen

# ✅ নতুন স্ক্রিনে যেতে → push() বা pushNamed()
✅ আগের সব স্ক্রিন মুছে নতুন স্ক্রিন লোড করতে → go()
✅ শুধুমাত্র বর্তমান স্ক্রিন মুছে নতুন স্ক্রিন লোড করতে → replace()
✅ ব্যাক বাটনের মতো কাজ করতে → pop()
✅ ব্যাক করা সম্ভব কিনা চেক করতে → canPop()
✅ সকল স্ক্রিন মুছে প্রথম স্ক্রিনে নিতে → popUntil((route) => route.isFirst);
✅ লগইন বা অনবোর্ডিং শেষ করে হোম স্ক্রিনে পাঠাতে → pushReplacement()



//

 # Phone Number Verification
# Push Notification
# Messaging
# Apple Login
# Facebook login
# google login
# Scanner
# location

 
