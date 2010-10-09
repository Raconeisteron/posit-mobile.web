-- phpMyAdmin SQL Dump
-- version 2.9.1.1-Debian-6
-- http://www.phpmyadmin.net
-- 
-- Host: localhost
-- Generation Time: Oct 09, 2010 at 05:25 PM
-- Server version: 5.0.32
-- PHP Version: 5.2.0-8+etch7
-- 
-- Database: `ram_posit_august2010`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `audio`
-- 

DROP TABLE IF EXISTS `audio`;
CREATE TABLE IF NOT EXISTS `audio` (
  `id` int(11) NOT NULL,
  `find_id` int(11) NOT NULL,
  `mime_type` varchar(32) NOT NULL,
  `data_path` varchar(30) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `find_id` (`find_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `device`
-- 

DROP TABLE IF EXISTS `device`;
CREATE TABLE IF NOT EXISTS `device` (
  `imei` varchar(16) default NULL,
  `name` varchar(32) default NULL,
  `user_id` int(11) NOT NULL,
  `auth_key` varchar(32) NOT NULL,
  `add_time` datetime NOT NULL,
  `status` set('pending','ok') NOT NULL default 'pending',
  PRIMARY KEY  (`auth_key`),
  UNIQUE KEY `imei` (`imei`),
  KEY `user_id` (`user_id`),
  KEY `status` (`status`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `expedition`
-- 

DROP TABLE IF EXISTS `expedition`;
CREATE TABLE IF NOT EXISTS `expedition` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(32) default 'Expedition',
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `description` text,
  `add_time` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `modify_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=87 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `find`
-- 

DROP TABLE IF EXISTS `find`;
CREATE TABLE IF NOT EXISTS `find` (
  `id` mediumint(9) NOT NULL auto_increment,
  `project_id` int(11) NOT NULL,
  `description` varchar(100) NOT NULL,
  `guid` varchar(64) default NULL,
  `name` varchar(32) NOT NULL,
  `add_time` datetime NOT NULL,
  `modify_time` datetime NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `revision` int(11) NOT NULL,
  `imei` varchar(50) NOT NULL,
  `auth_key` varchar(32) NOT NULL,
  `deleted` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `guid` (`guid`),
  KEY `project_id` (`project_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=116 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `find_history`
-- 

DROP TABLE IF EXISTS `find_history`;
CREATE TABLE IF NOT EXISTS `find_history` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `time` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `find_guid` varchar(64) NOT NULL,
  `action` varchar(20) NOT NULL,
  `imei` varchar(50) NOT NULL,
  `auth_key` varchar(64) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=150 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `forms`
-- 

DROP TABLE IF EXISTS `forms`;
CREATE TABLE IF NOT EXISTS `forms` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `title` varchar(40) NOT NULL,
  `form` blob NOT NULL,
  `xml` longtext NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `gps_sample`
-- 

DROP TABLE IF EXISTS `gps_sample`;
CREATE TABLE IF NOT EXISTS `gps_sample` (
  `id` int(11) NOT NULL auto_increment,
  `sample_time` datetime NOT NULL,
  `expedition_id` int(11) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `altitude` double NOT NULL,
  `swath` int(11) NOT NULL,
  `time` bigint(17) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10475 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `logs`
-- 

DROP TABLE IF EXISTS `logs`;
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL auto_increment,
  `time` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `type` varchar(1) NOT NULL,
  `tag` varchar(10) NOT NULL,
  `message` varchar(30) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `photo`
-- 

DROP TABLE IF EXISTS `photo`;
CREATE TABLE IF NOT EXISTS `photo` (
  `id` int(11) NOT NULL auto_increment,
  `guid` varchar(64) NOT NULL,
  `project_id` int(11) NOT NULL,
  `identifier` bigint(17) NOT NULL,
  `mime_type` varchar(32) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `data_full` blob NOT NULL,
  `data_thumb` blob NOT NULL,
  `imei` varchar(50) NOT NULL,
  `auth_key` varchar(64) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `guid` (`guid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=78 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `project`
-- 

DROP TABLE IF EXISTS `project`;
CREATE TABLE IF NOT EXISTS `project` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(32) NOT NULL,
  `description` text NOT NULL,
  `create_time` datetime NOT NULL,
  `permission_type` set('open','closed') NOT NULL default 'open',
  `deleted` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `sync_history`
-- 

DROP TABLE IF EXISTS `sync_history`;
CREATE TABLE IF NOT EXISTS `sync_history` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `imei` varchar(50) NOT NULL,
  `auth_key` varchar(64) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=402 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `user`
-- 

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(32) NOT NULL,
  `password` varchar(40) NOT NULL,
  `first_name` varchar(32) NOT NULL,
  `last_name` varchar(32) NOT NULL,
  `privileges` set('normal','admin') NOT NULL default 'normal',
  `validated` tinyint(1) default '0',
  `create_time` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `user_project`
-- 

DROP TABLE IF EXISTS `user_project`;
CREATE TABLE IF NOT EXISTS `user_project` (
  `user_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `role` set('owner','user') default NULL,
  KEY `user_id` (`user_id`,`project_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `video`
-- 

DROP TABLE IF EXISTS `video`;
CREATE TABLE IF NOT EXISTS `video` (
  `id` int(11) NOT NULL,
  `find_id` int(11) NOT NULL,
  `mime_type` varchar(32) NOT NULL,
  `data_path` varchar(30) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `find_id` (`find_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
