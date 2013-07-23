/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
  config.PreserveSessionOnFileBrowser = true;
  // Define changes to default configuration here. For example:
  config.language = 'en';
  config.uiColor = '#f4f4f4';

  //config.ContextMenu = ['Generic','Anchor','Flash','Select','Textarea','Checkbox','Radio','TextField','HiddenField','ImageButton','Button','BulletedList','NumberedList','Table','Form'] ; 
  
  config.height = '300px';
  config.width = '78%';
  
  //config.resize_enabled = false;
  //config.resize_maxHeight = 2000;
  //config.resize_maxWidth = 750;
  
  //config.startupFocus = true;
  
  // works only with en, ru, uk languages
  config.extraPlugins = "embed,attachment";
  config.entities = false;
  
  config.toolbar = 'Easy';
  
  config.toolbar_Easy =
    [
        ['Source', 'Cut','Copy','Paste','PasteText','PasteFromWord'],
        ['Bold','Italic','Underline', 'NumberedList','BulletedList'],
        ['Blockquote', 'Link','Unlink','Image','Table','Embed']
    ];
};

