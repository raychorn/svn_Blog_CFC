# MySQL-Front 3.2  (Build 6.25)

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES 'latin1' */;

# Host: localhost    Database: blogdev
# ------------------------------------------------------
# Server version 4.1.11-nt
/*!40101 SET NAMES utf8 */;


#
# Table structure for table tblblogcategories
#

DROP TABLE IF EXISTS `tblblogcategories`;
CREATE TABLE `tblblogcategories` (
  `categoryid` varchar(35) character set utf8 NOT NULL default '',
  `categoryname` varchar(50) character set utf8 NOT NULL default '',
  `blog` varchar(50) character set utf8 NOT NULL default '',
  PRIMARY KEY  (`categoryid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#
# Table structure for table tblblogcomments
#

DROP TABLE IF EXISTS `tblblogcomments`;
CREATE TABLE `tblblogcomments` (
  `id` varchar(35) character set utf8 NOT NULL default '',
  `entryidfk` varchar(35) character set utf8 default NULL,
  `name` varchar(50) character set utf8 default NULL,
  `email` varchar(50) character set utf8 default NULL,
	`website` varchar(255) character set utf8 default NULL,
  `comment` text character set utf8,
  `posted` datetime default NULL,
  `subscribe` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#
# Table structure for table tblblogentries
#

DROP TABLE IF EXISTS `tblblogentries`;
CREATE TABLE `tblblogentries` (
  `id` varchar(35) character set utf8 NOT NULL default '',
  `title` varchar(100) character set utf8 NOT NULL default '',
  `body` text character set utf8 NOT NULL,
  `posted` datetime NOT NULL default '0000-00-00 00:00:00',
  `morebody` text character set utf8,
  `alias` varchar(100) character set utf8 default NULL,
  `username` varchar(50) character set utf8 default NULL,
  `blog` varchar(50) character set utf8 NOT NULL default '',
  `allowcomments` tinyint(1) NOT NULL default '0',
  `enclosure` varchar(255) character set utf8 default NULL,
  `filesize` int(11) unsigned default '0',
  `mimetype` varchar(255) character set utf8 default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#
# Table structure for table tblblogentriescategories
#

DROP TABLE IF EXISTS `tblblogentriescategories`;
CREATE TABLE `tblblogentriescategories` (
  `categoryidfk` varchar(35) character set utf8 default NULL,
  `entryidfk` varchar(35) character set utf8 default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#
# Table structure for table tblblogsubscribers
#

DROP TABLE IF EXISTS `tblblogsubscribers`;
CREATE TABLE `tblblogsubscribers` (
  `email` varchar(50) character set utf8 NOT NULL default '',
  `token` varchar(35) character set utf8 NOT NULL default '',
  `blog` varchar(50) character set utf8 default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#
# Table structure for table tblusers
#

DROP TABLE IF EXISTS `tblusers`;
CREATE TABLE `tblusers` (
  `username` varchar(50) character set utf8 default NULL,
  `password` varchar(50) character set utf8 default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#
# Table structure for table tblblogtrackbacks
#

DROP TABLE IF EXISTS `tblblogtrackbacks`;
CREATE TABLE `tblblogtrackbacks` (
  `Id` varchar(35) character set utf8 NOT NULL default '',
  `title` varchar(255) character set utf8 NOT NULL default '',
  `blogname` varchar(255) character set utf8 NOT NULL default '',
  `posturl` varchar(255) character set utf8 NOT NULL default '',
  `excerpt` text character set utf8 NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `entryid` varchar(35) character set utf8 NOT NULL default '',
  `blog` varchar(50) character set utf8 NOT NULL default '',
  PRIMARY KEY  (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#
# Table structure for table tblblogsearchstats
#

DROP TABLE IF EXISTS `tblblogsearchstats`;
CREATE TABLE `tblblogsearchstats` (
  `searchterm` varchar(255) character set utf8 NOT NULL default '',
  `searched` datetime NOT NULL default '0000-00-00 00:00:00',
  `blog` varchar(50) character set utf8 NOT NULL default ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


/*!40101 SET NAMES latin1 */;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

insert into tblusers(username,password) values('admin','admin');
