About Diffly
------------

Diffly 0.9.0
http://lucidmac.com/diffly/

by Matt Mower <self@mattmower.com>
http://matt.blogs.it/

Diffly is Cocoa tool to help developers when committing changes to a
Subversion repository. Diffly provides a convenient tool for browsing
changes in working copies. If you're ready to commit Diffly helps
you create a great commit message and then does the commit for you.

Diffly isn't a general Subversion tool and is focused on making this
workflow as smooth and effective as possible.

Changes
-------
See changes.txt in the distribution file for a list of changes between
versions.

Main Features
-------------
Streamlined Cocoa interface
Easy way to browse the changes to an entire working copy
Select files, browse diffs, build a commit message and commit from within the tool
Bring up FileMerge for more context
Filter uninteresting files & folders

Getting Started
---------------

1. Drag Diffly.app to your /Applications folder (or whichever folder you want
	to run it from)
	
2. Open the Diffly application from /Applications (or your chosen folder)

3. It should ask if you want automatic updates. If you do not want Diffly
	to update automatically you can use the "Check for Updates" option of
	the Application menu at any time.

4. If your copy of Subversion is not located in /usr/local/bin then you need
	to configure Diffly's preferences to point at it. You can find your copy
	of subversion with the command:
	
		which svn
		
	Open preferences and set the Subversion path appropriately.
	
5. Close the preferences

6. Open a working copy. Remember that a working copy with no changes
	will not display any information.
	
Getting Started
---------------

Open a working copy in Diffly using File|Open Working Copy (Cmd+O).

The working copy window displays two panes that can be resized. The left
pane contains a table with each file or folder that has changes. The right
pane displays a syntax highlighted summary of changes for the selected
files.

If you are preparing to commit files hit the checkin toolbar button. This
opens the checkin panel where you can enter a commit message, and a set
of checkboxes that allow you to select files you want to commit. You can
continue to review changes while entering the message then hit the
commit button when you are ready.

Alternatively you can use the Export button to create a patch from the
selected changes. This may be required if you do not have commit rights
to the repository you have checked out from.

Keyboard Options
----------------

When working with the list of changed files you can select files singly
or in groups.

Files can be selected with '+' or the spacebar and de-selected with '-'.

Still to come
-------------

- Option to hide files (in the UI, not using svn:ignore)
- Svn remove
- Delete unversioned files
- Open file dialog at startup

Using the command line
----------------------

Diffly comes supplied with a sample comand line script. Copy this into
your search path and ensure it's executable (chmod u+x). It assumes that
Diffly has been installed in /Applications.

Then you can open Diffly on a folder as, ...

  diffly <foldername>

e.g. in a working copy you can say 

  diffly .

to open the current working directory.

Configuration
-------------

Diffly has just a few preferences. Two important ones are:

1) Whether Diffly should remember the working copies you
have open when you quit & re-open them when you start it again.

2) Whether Diffly should generate TextMate style URLs to
allow you to open any diff hunk directly in TextMate.

Customisation
-------------

Diffly comes with a built in stylesheet that you can override. Code blocks look like this:

<div class="diff">
	<p><a href="txmt://open?url=file:///Blah/file.ext">Line: 24</a></p>
	<div class="hunk">
		<pre><code>
			Changes go here
		</code></pre>
	</div>
	...more divs for each hunk...
</div>

Create your stylesheet and save it somewhere then change the Stylesheet Path in Diffly's preferences
to point at your stylesheet. If you want to go back to the default stylesheet just clear the text
box in the preferences.
