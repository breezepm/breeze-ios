breeze-ios
==========

Breeze (http://breeze.pm) is a simple project management tool that uses Kanban as it's main workflow method.


* 4 views 
  * activity list
  * project list view
  * project view
  * task view

* activity view
  * a list of recent project activities
  * https://dl.dropboxusercontent.com/u/3875110/activity.jpg

* project list view 
  * a list of projects (can't add new ones or delete)
  * https://dl.dropboxusercontent.com/u/3875110/projects_list.jpg

* project view 
  * project view is a view that contains lists and lists contain tasks. UIScrollview with paging or views with UIPageController - one task list is 
on one page.
  * move tasks between lists (drag and drop)
  * add new tasks
  * delete/archive tasks
  * https://dl.dropboxusercontent.com/u/3875110/project_view.jpg
  * if applicable use pre made libraries for drag and drop between views
    * https://github.com/Oblong/OBDragDrop
    * https://github.com/lxcid/LXReorderableCollectionViewFlowLayout
    * https://github.com/ice3-software/i3-dragndrop
    * https://github.com/ptoinson/asymptotik-drag-and-drop
    * https://github.com/frenetisch-applaudierend/ios-drag-and-drop

* task view 
  * edit task name and description
  * add/delete tags
  * add/delete due date and start date
  * assign/unassign to users
  * add/update/delete/ time entries
  * add/update/delete todos and todo lists
  * add/update/delete comments
  * archive task
  * https://dl.dropboxusercontent.com/u/3875110/task_view_1.jpg
  * https://dl.dropboxusercontent.com/u/3875110/task_view_menu.jpg
  * task view pull down menu https://github.com/BernardGatt/iOSPullDownMenu

* basic offline / local storage support
  * using RestKit http://restkit.org
  * only the projects that the user has opened will be cached locally
  * activities view list
  * projects list view
  * project view - only add new tasks (can't edit)
  * task view - only add comments (can't edit), mark todos done/undone 

* the app will use our JSON based API to communicate with the backend
  * API documentation http://breeze.pm/api 
  * we can modify and extend the API if it's necessary for the mobile app.

* main menu using RESideMenu https://github.com/romaonthego/RESideMenu
  * menu options - Projects, Activity, Log out

* login page
  * authentication to API using RestKit with HTTP Basic auth
  * username and password stored to Keychain

* target platform is iOS7 only
* the initial design will use the default iOS7 skin

