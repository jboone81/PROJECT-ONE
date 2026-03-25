# Selected Presentation Questions Form

## Course Information
- Course Name: Mobile App Development
- Course Section: 4360
- Instructor: Louis Henry
- Semester/Term: Spring 2026

## Team Information
- Group Name: Do-It
- App/Project Title: HQ - Habit Quest
- Presentation Date: 3/23/2026

### Team Members
1. Ugochukwu Odinjor
2. Joseph Boone
3. 
4. 

## Selected Questions (Choose 10–15)

Use this section to list the specific Project1Q&A questions your team selected for presentation.

1. Question: What are the key advantages of using Flutter for this cross-platform project?
   - Category: Flutter Framework & Cross-Platform Concepts
   - Team Member Responsible: Ugochukwu Odinjor
   - Evidence to Show (code file/commit/UI/screenshot):
   - Using Flutter allows our product to reach a wide range of audiences. With Flutter being cross-platform and powered by dart it allowed us to build a fast and high performing app- HQ.; that  is also aesthetically pleasing do to its widget capabilities. 
   

2. Question: Which state management technique did you choose (setState, Provider, Riverpod, BLoC) and why?
   - Category: State Management
   - Team Member Responsible: Ugochukwu Odinjor
   - Evidence to Show (code file/commit/UI/screenshot): ![alt text](image-1.png)
   - Speaking of widgets we were able to manage them through the setState() provided by Flutter.  We did this because most of our widgets are stateful, so whenever changes are added, deleted, or updated data wise we are simply updating the user interface data wise and setState() allows this.
   

3. Question: Describe one state-flow interaction from user action to UI update in your app.
   - Category: State Management
   - Team Member Responsible: Ugochukwu Odinjor
   - Evidence to Show (code file/commit/UI/screenshot): ![alt text](image-2.png)
   - One of the key state-flow interaction within HQ is the creation of missions. Users can create missions with a set XP value. They can mark as completed thereafter to get said experience. 
   

4. Question: What state-related challenge did you face, and what fix improved reliability?
   - Category:  State Management
   - Team Member Responsible: Ugochukwu Odinjor
   - Evidence to Show (code file/commit/UI/screenshot):
   - A current problem we are facing is the creation of missions being stifled due to the asynchronous creation of the database taking so long. We have employed several the only one that stuck being preemptively loading the database, however that seems to still be an issue.
   

5. Question: How did you make the interface intuitive and responsive across device sizes/orientations?
   - Category: UI/UX Design
   - Team Member Responsible: Both
   - Evidence to Show (code file/commit/UI/screenshot): ![alt text](image-3.png)
   - To make the interface intuitive and responsive across devices we provide the blueprint of wanting 4 screens, what they should capable of , and how they should interact with each other to ai and it built the design provided that we gave it a theme to follow. Each screen had its on class, stateful. Within said class we used multiple widgets to provide the UI that you see now. It mainly consist of padding functions because that’s what allows flutter to be intuitive across devices without providing specs that confine it. 
   
   

6. Question: Explain your local data structure (tables/columns/keys or preference groups).
   - Category: Local Data Persistence (SQLite / SharedPreferences)
   - Team Member Responsible: Joseph Boone
   - Evidence to Show (code file/commit/UI/screenshot): ![alt text](image-4.png), ![alt text](image-5.png), ![alt text](image-6.png)
   - habits table — stores each habit the user creates with columns: id (primary key, auto-incremented), name (text), xp_reward (integer), streak (integer), is_completed (0 or 1), and created_at (timestamp)
   app_stats table — stores a single row of global user stats with columns: id (always 1), total_xp (integer), and best_streak (integer) — this persists the user's XP and best streak across sessions
   habit_history table — logs every habit completion event with columns: id (primary key), habit_id (foreign key referencing habits), habit_name (text), xp_earned (integer), and completed_at (timestamp) — this powers the real data in the stats screen including the weekly heatmap and XP chart
   

7. Question: How are CRUD operations implemented and validated in your app?
   - Category: Local Data Persistence (SQLite / SharedPreferences)
   - Team Member Responsible: Joseph Boone
   - Evidence to Show (code file/commit/UI/screenshot): ![alt text](image-7.png)
   - Create — new habits are inserted into the database using insertHabit() when the user taps "CREATE MISSION" in the bottom sheet, returning the habit with its auto-generated id which is immediately added to the UI list
   Read — getAllHabits() and getAppStats() are called on app startup inside _loadData() in initState(), loading all saved habits, total XP, and best streak from the database so the user's data is restored every time the app opens
   Update — updateHabit() is called inside _toggleHabit() every time a user checks or unchecks a habit, saving the updated is_completed status and streak to the database, while updateAppStats() simultaneously saves the new total_xp and best_streak
   Delete — deleteHabit() is called when the user confirms deletion through the confirmation dialog, removing the habit from the habits table and automatically deleting all related entries in the habit_history table, keeping the database clean
   

8. Question: Share one meaningful commit message and explain why it communicates value clearly.
   - Category: Version Control (Git & GitHub)
   - Team Member Responsible: Ugochukwu Odinjor
   - Evidence to Show (code file/commit/UI/screenshot): ![alt text](image-8.png)
   - We used GitHub to administer version control for our product
   This one in particular set the stage for our product and let it be known to other collaborators that can begin to work on the product

9. Question: How did branching and pull requests help your team isolate and merge features safely?
   - Category: Version Control (Git & GitHub)
   - Team Member Responsible: Ugochukwu Odinjor
   - Evidence to Show (code file/commit/UI/screenshot): ![alt text](image-9.png)
   - Along with branching and merging it allowed us to keep historical version of our product before problems arise to analyze what went wrong. In particular the mission creating problem we are having right now. It improve testing capabilities, debugging efficiency, and overall work quality without being a hinderance to the development process. 

10. Question: How were responsibilities divided, and how did you ensure fair technical ownership?
   - Category: Team Collaboration
   - Team Member Responsible: Ugochukwu Odinjor 
   - Evidence to Show (code file/commit/UI/screenshot): 
   - Responsibilities were handled on a need to do and what can you do basis. Overall, they could have been handled better. The product could have been better. 
   

11. Question: Why is documentation essential for team continuity and future enhancement planning?
   - Category: Technical Documentation
   - Team Member Responsible: Ugochukwu Odinjor
   - Evidence to Show (code file/commit/UI/screenshot): 
   - The technical documentation was essential for team continuity and future enhancement planning because it shows were teams could have done better. To be frank this team did not take into account the amount of work we had to do. While we did turn in the product it is not something that I am happy and I am disappointed in myself. For future enhancement planning I need to be more organized and on time when it comes to managing workload


## Final Confirmation
- [X] This form includes the questions selected for our presentation.
- [X] We will submit this form at the same time as our project package.

Instruction Statement:
Please include a Selected Presentation Questions Form with your project. This document must list the questions you have chosen to incorporate into your presentation and should be submitted at the same time as your project.
