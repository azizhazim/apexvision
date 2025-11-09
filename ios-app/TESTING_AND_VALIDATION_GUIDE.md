# Testing & Validation Guide - ApexVision AI iOS App

## Overview
This guide provides comprehensive testing procedures to ensure the iOS app works perfectly with the existing backend and matches the Chrome extension experience.

---

## 🚀 Pre-Testing Setup

### Requirements:
- [ ] macOS with Xcode 14.0 or later
- [ ] iOS device or simulator running iOS 15.0+
- [ ] Active internet connection
- [ ] Test accounts (Google and Apple ID)
- [ ] Access to backend API (https://api.apexvision.ai)

### Initial Setup:
```bash
cd ios-app
pod install
open ApexVisionAI.xcworkspace
```

---

## 1️⃣ Authentication Testing

### 1.1 Google Sign-In (Existing Users)

**Test Case**: Existing user signs in with Google account

**Steps**:
1. Launch app
2. Tap "Sign in with Google"
3. Select existing Google account
4. Grant permissions

**Expected Results**:
- ✅ User is authenticated successfully
- ✅ User data loads from Firestore
- ✅ Subscription level displays correctly
- ✅ Request count shows accurate number
- ✅ User is redirected to main app

**Validation**:
```
Check Firestore 'tokens' collection:
- Document ID matches user_id
- subscription_level field is correct
- request_count is accurate
- email matches Google account
```

---

### 1.2 Apple Sign-In (New Users)

**Test Case**: New user signs up with Apple ID

**Steps**:
1. Launch app
2. Tap "Sign in with Apple"
3. Complete Apple authentication
4. Grant permissions

**Expected Results**:
- ✅ User is authenticated successfully
- ✅ New user document created in Firestore
- ✅ Default subscription level: "No subscription"
- ✅ Default request count: 0
- ✅ Free requests: 15

**Validation**:
```
Check Firestore 'tokens' collection:
- New document created
- subscription_level: "No subscription"
- request_count: 0
- free_requests_remaining: 15
```

---

### 1.3 Account Linking

**Test Case**: User with Google account signs in with Apple

**Steps**:
1. Sign in with Google (existing account)
2. Sign out
3. Sign in with Apple (same email)

**Expected Results**:
- ✅ Backend links accounts
- ✅ Same user_id returned
- ✅ Subscription data preserved
- ✅ Request count preserved

---

### 1.4 Sign-Out

**Test Case**: User signs out

**Steps**:
1. Sign in with any method
2. Navigate to Settings
3. Tap "Sign Out"

**Expected Results**:
- ✅ User is signed out
- ✅ Returns to login screen
- ✅ All user data cleared from memory
- ✅ Can sign in again

---

## 2️⃣ API Endpoint Testing

### 2.1 Chat/AI Response (`/get_gpt_response`)

**Test Case**: Send message to AI

**Steps**:
1. Navigate to Chat tab
2. Type: "What is photosynthesis?"
3. Send message

**Expected Results**:
- ✅ Loading indicator appears
- ✅ AI response received within 5 seconds
- ✅ Response is relevant and well-formatted
- ✅ Request count increments by 1
- ✅ Message appears in chat history

**API Validation**:
```json
Request:
{
  "userInput": "What is photosynthesis?"
}

Response:
{
  "response": "Photosynthesis is..."
}
```

---

### 2.2 Image Analysis (`/analyze_image`)

**Test Case**: Analyze image with text/math

**Steps**:
1. Navigate to Scan tab
2. Take photo or select from library
3. Wait for analysis

**Expected Results**:
- ✅ Image uploads successfully
- ✅ OCR extracts text correctly
- ✅ AI provides relevant explanation
- ✅ Request count increments
- ✅ Can save or share result

**Test Images**:
- Math equation (handwritten)
- Printed text document
- Diagram or chart
- Mixed text and images

---

### 2.3 Exam Prediction (`/exam_prediction`)

**Test Case**: Generate exam questions

**Steps**:
1. Navigate to Exam Prep tab
2. Enter course name: "Biology 101"
3. Upload study materials (text or PDF)
4. Generate predictions

**Expected Results**:
- ✅ Predictions generated (5-15 questions)
- ✅ Each question has confidence score
- ✅ Topics are relevant to materials
- ✅ Priority levels assigned (HIGH/MEDIUM/LOW)
- ✅ Study priority topics listed

**Subscription Check**:
- Free: 5 predictions/month
- Knowledge Kickstart: 5 predictions/month
- Savvy Scholar: 10 predictions/month
- Mastermind: Unlimited

---

### 2.4 Generate Answer (`/generate_answer`)

**Test Case**: Get detailed answer for exam question

**Steps**:
1. From exam predictions, select a question
2. Tap "Get Answer"
3. Wait for response

**Expected Results**:
- ✅ Detailed answer provided
- ✅ Step-by-step explanation
- ✅ Key concepts highlighted
- ✅ Common mistakes mentioned
- ✅ Tips for similar questions

---

### 2.5 Essay Writer (`/generate_essay`)

**Test Case**: Generate essay

**Steps**:
1. Navigate to Essay tab
2. Enter topic: "Climate Change Impact"
3. Set word count: 500
4. Select essay type: "Argumentative"
5. Generate essay

**Expected Results**:
- ✅ Essay generated within 30 seconds
- ✅ Word count approximately matches request
- ✅ Proper structure (intro, body, conclusion)
- ✅ Can export to PDF
- ✅ Request count increments

---

### 2.6 Flashcards (`/flashcards`)

**Test Case**: Generate flashcards

**Steps**:
1. Navigate to More → Flashcards
2. Enter topic: "World War II"
3. Generate flashcards

**Expected Results**:
- ✅ 10-15 flashcards generated
- ✅ Each has question and answer
- ✅ Can flip cards
- ✅ Can mark as learned
- ✅ Can shuffle deck

---

### 2.7 Math Solver (`/math`)

**Test Case**: Solve math problem

**Steps**:
1. Navigate to More → Math Solver
2. Enter: "Solve: 2x + 5 = 15"
3. Submit

**Expected Results**:
- ✅ Step-by-step solution provided
- ✅ Final answer: x = 5
- ✅ Explanation of each step
- ✅ Can handle various math types (algebra, calculus, etc.)

---

### 2.8 Code Helper (`/code`)

**Test Case**: Get coding help

**Steps**:
1. Navigate to More → Code Helper
2. Enter: "Write a Python function to reverse a string"
3. Submit

**Expected Results**:
- ✅ Code snippet provided
- ✅ Syntax highlighting
- ✅ Explanation included
- ✅ Can copy code
- ✅ Multiple language support

---

### 2.9 Study Guide (`/study_guide_module`)

**Test Case**: Generate study guide

**Steps**:
1. Navigate to More → Study Guide
2. Enter conversation or topic
3. Generate guide

**Expected Results**:
- ✅ Comprehensive study guide created
- ✅ Key topics organized
- ✅ Summary sections
- ✅ Can export or save

---

### 2.10 Leaderboard (`/leaderboard/submit`, `/leaderboard/global`)

**Test Case**: View and submit to leaderboard

**Steps**:
1. Navigate to More → Leaderboard
2. View global rankings
3. Submit stats (if applicable)

**Expected Results**:
- ✅ Global leaderboard loads
- ✅ User's rank displayed
- ✅ Stats update correctly
- ✅ Streak tracking works

---

## 3️⃣ Subscription Testing

### 3.1 Free Tier (No Subscription)

**Limits**: 15 requests total

**Test**:
1. Create new account
2. Make 15 requests
3. Attempt 16th request

**Expected**:
- ✅ First 15 requests succeed
- ✅ 16th request shows limit message
- ✅ Prompt to upgrade subscription

---

### 3.2 Knowledge Kickstart

**Limits**: 500 requests/month

**Test**:
1. Account with Knowledge Kickstart subscription
2. Verify request limit displays "500"
3. Make requests and watch counter

**Expected**:
- ✅ Limit shows 500
- ✅ Counter increments correctly
- ✅ Resets monthly

---

### 3.3 Savvy Scholar

**Limits**: 1000 requests/month

**Test**:
1. Account with Savvy Scholar subscription
2. Verify request limit displays "1000"

**Expected**:
- ✅ Limit shows 1000
- ✅ All features accessible

---

### 3.4 Mastermind

**Limits**: 2000 requests/month + advanced features

**Test**:
1. Account with Mastermind subscription
2. Verify request limit displays "2000"
3. Test Mathpix integration (if available)

**Expected**:
- ✅ Limit shows 2000
- ✅ Advanced features enabled
- ✅ Mathpix OCR available

---

## 4️⃣ Theme Testing

### 4.1 Light Mode

**Test**:
1. Enable light mode in Settings
2. Navigate through all screens

**Verify Colors**:
- ✅ Panel background: #F1F1F2
- ✅ Primary text: #121212 (83% opacity)
- ✅ User bubble: #0056B3
- ✅ AI bubble: rgba(0,0,0,0.03)
- ✅ Primary blue: #4A90E2

---

### 4.2 Dark Mode

**Test**:
1. Enable dark mode in Settings
2. Navigate through all screens

**Verify Colors**:
- ✅ Panel background: #282828
- ✅ Primary text: #F5F5F5
- ✅ User bubble: #007BFF
- ✅ AI bubble: rgba(255,255,255,0.05)
- ✅ Primary blue: #4A90E2 (unchanged)

---

### 4.3 System Theme

**Test**:
1. Set to follow system theme
2. Change iOS system theme
3. Verify app updates

**Expected**:
- ✅ App theme matches system
- ✅ Smooth transition
- ✅ All colors update correctly

---

## 5️⃣ Error Handling

### 5.1 Network Errors

**Test**:
1. Disable internet
2. Attempt to make request

**Expected**:
- ✅ Error message displayed
- ✅ Retry option available
- ✅ App doesn't crash

---

### 5.2 Invalid Responses

**Test**:
1. Simulate backend error (500)
2. Check app behavior

**Expected**:
- ✅ Error handled gracefully
- ✅ User-friendly message
- ✅ Can retry or go back

---

### 5.3 Authentication Failures

**Test**:
1. Attempt sign-in with invalid credentials
2. Cancel authentication mid-flow

**Expected**:
- ✅ Error message shown
- ✅ Can retry
- ✅ No data corruption

---

## 6️⃣ Performance Testing

### 6.1 Load Times

**Measure**:
- App launch: < 2 seconds
- API response: < 5 seconds
- Image upload: < 10 seconds
- Theme switch: Instant

---

### 6.2 Memory Usage

**Monitor**:
- Idle: < 100 MB
- Active use: < 200 MB
- No memory leaks

---

## 7️⃣ UI/UX Testing

### 7.1 Navigation

**Test**:
- ✅ All tabs accessible
- ✅ Back navigation works
- ✅ Tab state preserved
- ✅ Smooth transitions

---

### 7.2 Input Validation

**Test**:
- ✅ Empty input handled
- ✅ Long text handled
- ✅ Special characters work
- ✅ Emoji support

---

### 7.3 Accessibility

**Test**:
- ✅ VoiceOver support
- ✅ Dynamic type support
- ✅ Color contrast (WCAG AA)
- ✅ Touch targets (44x44 pt minimum)

---

## ✅ Final Checklist

### Before App Store Submission:
- [ ] All authentication flows tested
- [ ] All API endpoints verified
- [ ] All subscription tiers tested
- [ ] Light/dark mode verified
- [ ] Error handling confirmed
- [ ] Performance benchmarks met
- [ ] UI/UX polished
- [ ] No crashes or bugs
- [ ] Privacy policy added
- [ ] Terms of service added
- [ ] App icons created
- [ ] Screenshots prepared
- [ ] App Store description written

---

**Testing Completed By**: _________________
**Date**: _________________
**iOS Version Tested**: _________________
**Device Tested**: _________________
**Build Number**: _________________

