<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
  "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" /> 
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <title>ODK Build</title>

    <link rel="stylesheet" type="text/css" href="../res/style/css/build/style.css"/>
    <link rel="stylesheet" type="text/css" href="../res/style/css/build/jquery-ui-1.7.2.custom.css"/>
  </head>
  <body>
    <div class="loadingScreen">
      <div class="loadingMessage">
        <h1>loading <strong>odk build</strong><sup>BETA</sup></h1>
        <p>version 0.8</p>
        <div class="loadingBar">please wait.</div>
        <p class="status">loading application...</p>
      </div>
    </div>
    <div class="preloadImages">
      <img src="images/control_slice.png"/>
      <img src="images/control_arrows.png"/>
      <img src="images/group_bg.png"/>
      <img src="images/type_icons.png"/>
    </div>
    <div class="toast"></div>
    <div class="header">
      <h1>Untitled Form</h1>
      <input type="text" id="renameFormField"/>
      <a id="editTitleLink" href="#edit_title" title="Rename this form">Rename</a>

      <ul class="menu">
        <li>
          <span>File</span>
          <ul class="submenu">
            <li><a href="#newFormDialog" class="destructive newLink">New Form</a></li>
            <li><a href="#openDialog" rel="modal" class="destructive">Open Form...</a></li>
            <li class="divider"></li>
            <li><a href="#saveForm" class="authRequired saveLink">Save</a></li>
            <li><a href="#saveAsDialog" rel="modal" class="">Save Form As...</a></li>
            <li class="divider"></li>
            <li><a href="#exportDialog" id="exportLink" rel="modal">Export to XML...</a></li>
          </ul>
        </li>
        <li>
          <span>Edit</span>
          <ul class="submenu">
            <li class="disabled"><a href="#cut">Cut</a></li>
            <li class="disabled"><a href="#copy">Copy</a></li>
            <li class="disabled"><a href="#paste">Paste</a></li>
            <li class="divider"></li>
            <li class="disabled"><a href="#undo">Undo</a></li>
            <li class="disabled"><a href="#redo">Redo</a></li>
            <li class="divider"></li>
            <li><a href="#translationsDialog" class="manageTranslations" rel="modal">Manage Translations...</a></li>
          </ul>
        </li>
        <li>
          <span>View</span>
          <ul class="submenu">
            <li class="infoText">Displayed Language</li>
            <li>
              <ul class="displayLanguages">
                <li><a href="#" rel="eng">English</a></li>
              </ul>
            </li>
            <li class="divider"></li>
            <li class="disabled"><a href="#toggleCollapsedMode">Collapse Controls</a></li>
          </ul>
        </li>
        <li>
          <span>Help</span>
          <ul class="submenu">
            <li class="disabled"><a href="#toggleHints">Display Hints</a></li>
            <li class="disabled"><a href="#tutorial">Tutorial</a></li>
            <li><a href="#aboutDialog" rel="modal">About ODK Build...</a></li>
          </ul>
        </li>
      </ul>

      <div class="accountStatus"></div>
    </div>
    <div class="mainWrapper">
      <div class="toolPalette">
        <h3>Add new</h3>
        <ul>
          <li><a class="toolButton inputText" rel="inputText">Text</a></li>
          <li><a class="toolButton inputNumeric" rel="inputNumeric">Numeric</a></li>
          <li><a class="toolButton inputDate" rel="inputDate">Date</a></li>
          <li><a class="toolButton inputLocation" rel="inputLocation">Location</a></li>
          <li><a class="toolButton inputMedia" rel="inputMedia">Media</a></li>
          <li><a class="toolButton inputSelectOne" rel="inputSelectOne">Choose One</a></li>
          <li><a class="toolButton inputSelectMany" rel="inputSelectMany">Select Multiple</a></li>
          <li class="separator"></li>
          <li><a class="toolButton group" rel="group">Group</a></li>
          <li class="disabled"><a class="branch" rel="branch">Branch</a></li>
        </ul>
      </div>
      <div class="workspaceScrollArea">
        <div class="workspace"></div>
      </div>
      <div class="propertiesPane">
        <h3>Properties</h3>
        <ul class="propertyList">
          <li class="emptyData">First add a control, then select it to view its properties here.</li>
        </ul>
      </div>
    </div>

    <div class="modal narrowModal signinDialog">
      <h3>Sign in</h3>
      <div class="modalContents">
        <p>You must have an account in order to create forms on ODK Build.</p>

        <div class="errorMessage"></div>

        <form>
          <label for="signin_username">Username</label>
          <input type="text" id="signin_username" name="username" />
          <div class="signin_section">
            <label for="signin_password">Password</label>
            <input type="password" id="signin_password" name="password" />
          </div>
          <div class="signup_section">
            <label for="signup_password_confirm">Password (confirm)</label>
            <input type="password" id="signup_password_confirm" name="password_confirm" />
            <label for="signup_email">Email</label>
            <input type="text" id="signup_email" name="email" />
          </div>
          <p><a href="#forgotPassword" class="togglePasswordLink">Forgot your password?</a></p>
          <p><a href="#signUp" class="toggleSignupLink">Don't yet have an account?</a></p>
        </form>
      </div>
      <div class="modalButtonContainer">
        <a class="modalButton signinLink" href="#signin">Sign in</a>
        <a class="modalButton signupLink hide" href="#signin">Sign up</a>
        <a class="modalButton passwordLink hide" href="#signin">Reset password</a>
        <a class="modalButton jqmClose" href="#close">Cancel</a>
      </div>
    </div>

    <div class="modal narrowModal accountDialog">
      <h3>My account</h3>
      <div class="modalContents">
        <form>
          <div class="errorMessage"></div>

          <label for="account_email">Email Address</label>
          <input type="text" id="account_email" name="email" />

          <p>Fill these out only if you wish to change your password:</p>
          <label for="account_old_password">Old Password</label>
          <input type="password" id="account_old_password" name="old_password" />
          <label for="account_password">New Password</label>
          <input type="password" id="account_password" name="password" />
          <label for="account_password_confirm">New Password (confirm)</label>
          <input type="password" id="account_password_confirm" />
        </form>
      </div>
      <div class="modalButtonContainer">
        <a class="modalButton updateAccountLink acceptLink" href="#update">Update</a>
        <a class="modalButton jqmClose" href="#close">Cancel</a>
      </div>
    </div>

    <div class="modal narrowModal openDialog">
      <h3>Open Form</h3>
      	<p>Select a form to open:</p>
      <div class="modalContents formBox">
        <form>
          <div class="errorMessage"></div>

  
          <ul class="formList"></ul>
        </form>
      </div>
      <div class="modalButtonContainer">
        <a class="modalButton openLink acceptLink" href="#open">Open</a>
        <a class="modalButton jqmClose" href="#close">Cancel</a>
      </div>
    </div>

    <div class="modal narrowModal saveAsDialog">
      <h3>Save Form As</h3>
      <div class="modalContents">
        <form>
          <div class="errorMessage"></div>

          <label for="saveAs_name">Form Name</label>
          <input type="text" id="saveAs_name" name="name" />
        </form>
      </div>
      <div class="modalButtonContainer">
        <a class="modalButton saveAsLink acceptLink" href="#save">Save</a>
        <a class="modalButton jqmClose" href="#close">Cancel</a>
      </div>
    </div>

    <div class="modal exportDialog">
      <h3>Export</h3>
      <div class="modalContents">
        <h4>Output XML</h4>
        <div class="exportCodeContainer">
          <pre></pre>
        </div>
        <iframe id="downloadFrame"></iframe>
      </div>
      <div class="modalButtonContainer">
        <a class="modalButton downloadLink" href="#download">Download</a>
        <a class="modalButton jqmClose" href="#close">Done</a>
      </div>
    </div>

    <div class="modal narrowModal translationsDialog">
      <h3>Translations</h3>
      <div class="modalContents">
        <h4>Active languages</h4>
        <p class="translationNone">(none)</p>
        <ul class="translationList"></ul>

        <h4>Add a new language</h4>
        <select class="translationSelect"></select>
        <a class="addTranslation" href="#addTranslation">Add Translation</a>
      </div>
      <div class="modalButtonContainer">
        <a class="modalButton jqmClose" href="#close">Done</a>
      </div>
    </div>

    <div class="modal narrowModal aboutDialog">
      <h3>About</h3>
      <div class="modalContents">
        <p>
          ODK Build is part of the <a href="http://opendatakit.org/" rel="external">Open Data
          Kit</a> suite of tools. It is licensed under the
          <a href="http://www.apache.org/licenses/LICENSE-2.0" rel="external">Apache License 2.0</a>.
          You can find the source code on
          <a href="http://github.com/clint-tseng/odkmaker" rel="external">GitHub</a>.
        </p>
        <p>
          Built by <a href="http://change.washington.edu/people/cxlt" rel="external">Clint
          Tseng</a> in Seattle, Bangalore, Pittsburgh, and 40,000 feet in the air.
        </p>
        <p>
          Found a bug? Have a feature request?
          <a href="http://github.com/clint-tseng/odkmaker/issues" rel="external">Report it</a>.
        </p>
      </div>
      <div class="modalButtonContainer">
        <a class="modalButton jqmClose" href="#close">Done</a>
      </div>
    </div>

    <script type="text/javascript" src="../res/js/build/jquery-1.4.2.js"></script>
    <script type="text/javascript" src="../res/js/build/underscore.min.js"></script>
    <script type="text/javascript" src="../res/js/build/json2.js"></script>
    <script type="text/javascript" src="../res/js/build/jquery-ui.js"></script>
    <script type="text/javascript" src="../res/js/build/jquery.ui.core.js"></script>
    <script type="text/javascript" src="../res/js/build/jquery.ui.draggable.js"></script>
    <script type="text/javascript" src="../res/js/build/jquery.ui.mouse.js"></script>
    <script type="text/javascript" src="../res/js/build/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="../res/js/build/jquery.validate.js"></script>
    <script type="text/javascript" src="../res/js/build/jquery.jqmodal.min.js"></script>
    <script type="text/javascript" src="../res/js/build/jquery.qtip-1.0.0-rc3.min.js"></script>
    <script type="text/javascript" src="../res/js/build/namespace.js"></script>
    <script type="text/javascript" src="../res/js/build/util.js"></script>
    <script type="text/javascript" src="../res/js/build/auth.js"></script>
    <script type="text/javascript" src="../res/js/build/data.js"></script>
    <script type="text/javascript" src="../res/js/build/data-ui.js"></script>
    <script type="text/javascript" src="../res/js/build/i18n.js"></script>
    <script type="text/javascript" src="../res/js/build/modals.js"></script>
    <script type="text/javascript" src="../res/js/build/property-editor.js"></script>
    <script type="text/javascript" src="../res/js/build/workspace-draggable.js"></script>
    <script type="text/javascript" src="../res/js/build/control.js"></script>
    <script type="text/javascript" src="../res/js/build/toolbutton.js"></script>
    <script type="text/javascript" src="../res/js/build/dropdown-menu.js"></script>
    <script type="text/javascript" src="../res/js/build/application.js"></script>

    <div id="templates">

      <div class="control">
        <div class="controlInfo">
          <div class="typeIcon"></div>
          <a href="#deleteControl" class="deleteControl">Delete</a>
          <h4 class="controlLabel"></h4>
          <h5 class="controlHint"></h5>
          <h5 class="controlName"></h5>
          <ul class="controlProperties"></ul>
        </div>
        <div class="controlFlowArrow"></div>
      </div>

      <div class="editors">
        <div class="text">
          <h4></h4>
          <p></p>
          <input type="text" class="editorTextfield"/>
        </div>

        <div class="bool">
          <input type="checkbox" class="editorCheckbox"/>
          <label></label>
          <p></p>
        </div>

        <div class="numericRange dateRange">
          <h4></h4>
          <p></p>
          <input id="property_range_enabled" type="checkbox" class="editorCheckbox"/>
          <label for="property_range_enabled">Enable</label>
          <h5>Minimum</h5>
          <input type="text" class="editorTextfield min"/>
          <h5>Maximum</h5>
          <input type="text" class="editorTextfield max"/>
        </div>

        <div class="uiText">
          <h4></h4>
          <p></p>
          <ul class="translations"></ul>
        </div>
          <li class="uiText-translation">
            <h5></h5>
            <input type="text" class="editorTextfield"/>
          </li>

        <div class="enum">
          <h4></h4>
          <p></p>
          <select class="editorSelect"></select>
        </div>

        <div class="optionsEditor">
          <h4></h4>
          <p></p>
          <ul class="optionsList"></ul>
          <a class="addOption" href="#addOption">Add Option</a>
        </div>
          <div class="optionsEditorValueField">
            <h5>Underlying Value</h5>
            <input type="text" class="editorTextfield underlyingValue"/>
          </div>

        <div class="loopEditor">
          <h4></h4>
          <p></p>
          
        </div>

      </div>

    </div>
  </body>
</html>