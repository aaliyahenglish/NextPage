# Original App Design Project - NextPage 

### Table of Contents

#### Overview

#### App Evaluation

#### Product Spec

#### Wireframes

#### Schema

##### Overview

**Description:** NextPage is a fun, swipe-based mobile app that helps readers quickly discover their next favorite book. Instead of browsing long, overwhelming lists, users swipe right on books that match their interests and swipe left on ones they want to skip. Think “Tinder for Books,” with a playful and romantic aesthetic.
Each book card displays the cover, synopsis, author, and store/Goodreads links. Books users swipe right on appear in the “Currently Seeing” section, reinforcing the dating-app theme.

**Category:** Entertainment / Book Discovery

**App Evaluation**

Attribute
**Category:** Entertainment / Book Reading

**Mobile:** Yes, designed primarily for mobile. The swipe gesture and card UI are uniquely suited for mobile devices.

**Story:**	The story focuses on helping readers “match” with books based on their taste, mood, and curiosity. It turns book discovery into a fun, personal experience.

**Market:**	Targeted toward teens and adults who enjoy reading — especially romance lovers, casual readers, and anyone who finds book apps overwhelming.

**Habit:**	Semi-daily. Users may open it when they want new recommendations, browse during downtime, or build a reading list.

**Scope:** This version focuses on the core experience—swipe-based book discovery and a “Currently Seeing” list. Future updates may include recommendations, genre filters, social features, and mood tracking.

**Product Spec**
**1. User Stories**
Required (Must-Have)

☑️ User can create an account and log in using Firebase Authentication.

☑️ User can view a deck of book cards.

☑️ User can swipe right to like a book (save it).

☑️ User can swipe left to skip a book.

☑️ User can tap a book card to view additional details (synopsis, author, links).

☑️ User can view all “liked” books in the Currently Seeing page.

☑️ App pulls book data from Google Books API.

📝 Optional (Nice-to-Have)

* Add a Refresh Button.

**2. Screen Archetypes**

* Login / Register Screen ➡️User can log in or sign up with Firebase.

* Home Screen (Book Cards) ➡️ Displays a stacked deck of book cards.

* User can swipe left/right.

* User can tap a card for details.

* Book Details Screen ➡️ Shows expanded info: cover, synopsis, author, purchase/Goodreads links.

*  “Currently Seeing” Screen ➡️ Displays a list of all books the user swiped right on.

* User can tap to re-view details.

* (Optional) Profile Screen ➡️ User preferences, saved genres, logout button.

**3. Navigation**

### Tab Navigation

* Home → Book Cards
* Currently Seeing → Saved/Liked Books
* Profile (optional for MVP)

### Flow Navigation

Login Screen → Home Screen

Home Screen (Swipe Cards) → Book Details Screen

Currently Seeing Screen → Book Details Screen

##### Wireframes

(Insert photos of hand-drawn sketches here)


### Schema
#### Models

##### User

* userId — String: Firebase Auth unique ID
  
* email — String: User email for authentication

* likedBooks — Array<String>: List of book IDs the user swiped right on

* createdAt — Date: Account creation timestamp
  
* Book (Stored minimally, fetched from Google Books API)
  
* bookId — String: Google Books ID
  
* title — String: Book title
  
* author — String: Book author
  
* coverUrl — String: URL to the book cover image
  
* description — String: Synopsis text
  
* infoLinks — Dictionary: URLs such as Amazon, Goodreads, etc.

**Networking**
**List of Network Requests**

### Home Screen

* GET request to Google Books API
/volumes?q=subject:fiction or another category
→ returns array of books to display as swipe cards.

### Book Details Screen

GET request to Google Books API
/volumes/{bookId}
→ retrieves full details for tapped book.

### Currently Seeing Screen (Firestore)

GET /users/{userId}/likedBooks
→ retrieves list of saved book IDs.

### Save Liked Book

POST /users/{userId}/likedBooks/{bookId}
→ Adds a book to the user’s saved list.

# Wireframe Images

<img width="863" height="644" alt="Screenshot 2025-11-23 at 5 07 26 PM" src="https://github.com/user-attachments/assets/f928ec5e-8fcc-47d6-8d54-6b135ca94d72" />

# Video Walkthrough

### Creating Firebase Server
![creatingfirebaseserver-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/c7547956-de13-4c26-a43f-667c31528c7d)

### Setting up App in XCode
![settingupxcodeandfirebasepart1-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/255598f2-abe2-428b-84b4-ec2bc7450473)

### Login View
![settinguploginviewui-ezgif com-video-to-gif-converter (1)](https://github.com/user-attachments/assets/04d6debe-44fc-4451-9d6e-c1fcec366c83)
![loginviewdemo-ezgif com-video-to-gif-converter (2)](https://github.com/user-attachments/assets/b5566dce-d04f-452f-8d6a-6099b9c62206)

### Profile View
![Screen20Recording202025-11-3020at206-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/6deba6fc-d188-4874-a6a0-cdf554f4e8d1)

### Swipe Demo
![swipedemo-ezgif com-video-to-gif-converter (1)](https://github.com/user-attachments/assets/19280973-f01b-4a1d-9802-b97dfe856dab)

### Detail View
![detailview-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/afeb8306-2b2e-4fe7-9315-2e2f2c1e4326)

### Saved Book View (Currently Seeing View)
![savedbooksdemo4-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/7c8e9425-1b0e-4f16-b5ab-4e298728891b)


# Demo Day Prep Video

Youtube Link ▶️ https://youtu.be/EOQeaKJ0Brk 



# Demo Day Video

Youtube Link ➡️ https://youtu.be/44aX6orBAaM?si=7OAAFvEQgz0W9Ite 
