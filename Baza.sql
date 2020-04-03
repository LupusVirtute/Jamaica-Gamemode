-- phpMyAdmin SQL Dump
-- version 4.7.5
-- https://www.phpmyadmin.net/
--
-- Host: i2.liveserver.pl
-- Generation Time: Jan 20, 2019 at 04:33 PM
-- Server version: 10.0.37-MariaDB-0+deb8u1
-- PHP Version: 5.6.38-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_10686`
--
CREATE DATABASE IF NOT EXISTS `db_10686` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `db_10686`;

-- --------------------------------------------------------
--
-- Table structure for table `RCa`
--
CREATE TABLE `RCa`(
  `id` int(11) NOT NULL,
  `car` int(11) NOT NULL DEFAULT '412',
  `interior` int(11) NOT NULL DEFAULT '0',
  `name` varchar(24) NOT NULL DEFAULT 'NoName'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--
-- Table structure for table `RCcp`
--
CREATE TABLE `RCcp`(
  `id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT '0.0',
  `y` float NOT NULL DEFAULT '0.0',
  `z` float NOT NULL DEFAULT '0.0',
  `p` int(11) NOT NULL DEFAULT '0',
  `t` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--
-- Table structure for table `RCsp`
--
CREATE TABLE `RCsp`(
  `id` int(11) NOT NULL,
  `x` float NOT NULL DEFAULT '0.0',
  `y` float NOT NULL DEFAULT '0.0',
  `z` float NOT NULL DEFAULT '0.0',
  `a` float NOT NULL DEFAULT '0.0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--
-- Table structure for table `GaS`
--

CREATE TABLE `GaS` (
  `id` int(11) NOT NULL,
  `name` varchar(24) NOT NULL DEFAULT 'Brak',
  `tag` varchar(6) NOT NULL DEFAULT 'Brk',
  `rspkt` int(11) NOT NULL DEFAULT '0',
  `Sx` float NOT NULL DEFAULT '0',
  `Sy` float NOT NULL DEFAULT '0',
  `Sz` float NOT NULL DEFAULT '0',
  `GOid` int(11) NOT NULL DEFAULT '-1',
  `color` int(11) NOT NULL DEFAULT '16777215',
  `Expire` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `GM`
--

CREATE TABLE `GM` (
  `DR` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `GM`
--

INSERT INTO `GM` (`DR`) VALUES
(12);

-- --------------------------------------------------------

--
-- Table structure for table `GZones`
--

CREATE TABLE `GZones` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT '-1',
  `name` varchar(24) NOT NULL DEFAULT 'noname',
  `minX` float NOT NULL DEFAULT '0',
  `minY` float NOT NULL DEFAULT '0',
  `maxX` float NOT NULL DEFAULT '0',
  `maxY` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `HoS`
--

CREATE TABLE `HoS` (
  `id` int(20) NOT NULL,
  `Estate` varchar(24) NOT NULL,
  `XP` float NOT NULL DEFAULT '0',
  `YP` float NOT NULL DEFAULT '0',
  `ZP` float NOT NULL DEFAULT '0',
  `Iid` int(11) NOT NULL DEFAULT '-1',
  `Oid` int(11) NOT NULL DEFAULT '-1',
  `Bin` int(11) NOT NULL DEFAULT '0',
  `pass` varchar(24) NOT NULL DEFAULT '-',
  `pre` int(20) NOT NULL DEFAULT '20',
  `pcsh` int(20) NOT NULL DEFAULT '5000',
  `lck` tinyint(1) NOT NULL DEFAULT '0',
  `expi` int(11) NOT NULL DEFAULT '0',
  `moi` int(11) NOT NULL DEFAULT '0',
  `Security` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `HoS`
--

INSERT INTO `HoS` (`id`, `Estate`, `XP`, `YP`, `ZP`, `Iid`, `Oid`, `Bin`, `pass`, `pre`, `pcsh`, `lck`, `expi`, `moi`, `Security`) VALUES
(1, 'Chujnia', 2522.87, -1679.37, 15.497, 69, -1, 1, '-', 35, 150, 0, 0, 0, 0),
(2, 'TwojaStara', 2492.29, -1686.49, 13.5122, 100, 1, 1, '-', 40000, 5000000, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `plys`
--

CREATE TABLE `plys` (
  `id` int(11) NOT NULL,
  `nck` varchar(24) NOT NULL DEFAULT 'NoName',
  `csh` int(11) NOT NULL DEFAULT '0',
  `rsp` int(11) NOT NULL DEFAULT '0',
  `kills` int(24) NOT NULL DEFAULT '0',
  `deaths` int(24) NOT NULL DEFAULT '0',
  `deta` int(24) NOT NULL DEFAULT '0',
  `pass` varchar(65) DEFAULT NULL,
  `salt` varchar(65) NOT NULL DEFAULT 'None',
  `AdmPerLevel` int(1) NOT NULL DEFAULT '0',
  `AdP` varchar(45) NOT NULL DEFAULT 'sIT',
  `Ban` int(1) NOT NULL DEFAULT '0',
  `BaT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reas` varchar(64) NOT NULL DEFAULT 'Not Def',
  `Mute` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `JaTi` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `JaTR` varchar(64) NOT NULL DEFAULT 'CLEAR',
  `ski` smallint(4) NOT NULL DEFAULT '0',
  `tkd` tinyint(1) NOT NULL DEFAULT '0',
  `sk` int(11) NOT NULL DEFAULT '0',
  `sde` int(11) NOT NULL DEFAULT '0',
  `OwOf` int(11) NOT NULL DEFAULT '-1',
  `Brsp` int(11) NOT NULL DEFAULT '0',
  `Bcsh` int(11) NOT NULL DEFAULT '0',
  `Warn` tinyint(1) NOT NULL DEFAULT '0',
  `Kmrnik` tinyint(1) NOT NULL DEFAULT '0',
  `Achievs` varchar(150) NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0',
  `OKi` int(11) NOT NULL DEFAULT '0',
  `ODe` int(11) NOT NULL DEFAULT '0',
  `PKi` int(11) NOT NULL DEFAULT '0',
  `PDe` int(11) NOT NULL DEFAULT '0',
  `MKi` int(11) NOT NULL DEFAULT '0',
  `MDe` int(11) NOT NULL DEFAULT '0',
  `SpKi` int(11) NOT NULL DEFAULT '0',
  `SpDe` int(11) NOT NULL DEFAULT '0',
  `TotOnl` int(11) NOT NULL DEFAULT '0',
  `colour` int(11) NOT NULL DEFAULT '0',
  `last_ip` varchar(16) NOT NULL DEFAULT '255.255.255.255',
  `last_gpci` varchar(40) NOT NULL,
  `GPid` int(11) NOT NULL DEFAULT '0',
  `iGid` int(11) NOT NULL DEFAULT '-1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `plys`
--

INSERT INTO `plys` (`id`, `nck`, `csh`, `rsp`, `kills`, `deaths`, `deta`, `pass`, `salt`, `AdmPerLevel`, `AdP`, `Ban`, `BaT`, `reas`, `Mute`, `JaTi`, `JaTR`, `ski`, `tkd`, `sk`, `sde`, `OwOf`, `Brsp`, `Bcsh`, `Warn`, `Kmrnik`, `Achievs`, `OKi`, `ODe`, `PKi`, `PDe`, `MKi`, `MDe`, `SpKi`, `SpDe`, `TotOnl`, `colour`, `last_ip`, `last_gpci`, `GPid`, `iGid`) VALUES
(1, 'KorwinPresident', 2000, 165353, 11, 30, 17, '936A5BBB0334C6A5B1E3B566737FDC643093B3665365EF8BC3E000B47198069C', ':^VAT2UEH5', 6, 'twojastara', 0, '2018-11-26 16:45:52', 'testy', '2018-11-26 16:45:52', '0000-00-00 00:00:00', 'Erased', 0, 0, 0, 2, 2, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 9, 23, 0, 0, 0, 0, 0, 0, 2107, -35847937, '83.23.26.166', 'AE995CCFEEDD5A9DCDE4ED8A5F99EA4CA984F994', 0, -1),
(2, 'Netrev.', 2000, 0, 0, 0, 0, '4335DF498D4611C76ACF1E747E295D801286A2146E4964646E9C15C32089627D', 'HBGW[_80?^', 0, 'sIT', 0, '2018-12-15 20:11:10', 'Not Def', '2018-12-15 20:11:10', '2018-12-15 20:11:10', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 2011, 0, '83.26.247.145', 'EAAA9DCCAA44DF4C8F950EC0F8C8FC89DCE894FC', 0, -1),
(3, 'EMTI_', 2000, 73, 0, 0, 0, '459C9177B111204775A7A9ABD6FEB07A9372CB8A043F6FD13587844E7A82A74B', ';I8/O;1DD3', 6, 'hyh12dw', 0, '2018-12-15 20:11:15', 'Not Def', '2018-12-15 20:11:15', '0000-00-00 00:00:00', 'Erased', 230, 0, 0, 0, -1, 30, 15000, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 29, 36, 0, 0, 0, 0, 0, 0, 14429, 16755455, '5.173.40.247', 'D8F054A94EF9EEC4DC9845C0DD9998C444ACE994', 0, -1),
(4, 'The_GodFather', 2000, 0, 1, 1, 1, 'E3F6F8AE91EEEEA71CCC183A0090A94CC1846C09A1A05E7AE8F7CD733E43AA14', ':D:DQY<OA0', 6, 'chuj', 0, '2018-12-15 20:41:53', 'pierdole to', '2018-12-15 20:41:53', '2018-12-15 20:41:53', 'CLEAR', 137, 0, 0, 0, -1, 0, 0, 0, 1, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 1854, 0, '185.54.102.196', '89DE099DE0E9CEC58ED8DCED89D0EC8DDE80EAED', 0, -1),
(5, 'MaTeR', 2000, 0, 0, 0, 0, 'C0C06855A870D5035E842D6FF9B79374A21AC54F492A747A755CF06ED231997F', '?HM:^0JD/D', 0, 'sIT', 0, '2018-12-19 17:13:57', 'Not Def', '2018-12-19 17:13:57', '2018-12-19 17:13:57', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(6, 'Mikolajek.', 2000, 0, 0, 0, 0, 'F1EB86024A5777B9CC7074C1EBD3252B014795618612955E34B97FB30DCFD2CA', '/?WL8@WDQ', 0, 'sIT', 0, '2018-12-22 14:03:11', 'Not Def', '2018-12-22 14:03:11', '2018-12-22 14:03:11', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 15, 0, '255.255.255.255', '', 0, -1),
(7, 'xd3', 2000, 0, 0, 0, 0, '0B11A706081F5D7ABCA71AB38C8D5BC8D76767996FE8B260EBE99CF04EABEEA1', '7GOB;YCOT7', 0, 'sIT', 0, '2018-12-22 14:29:41', 'Not Def', '2018-12-22 14:29:41', '2018-12-22 14:29:41', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(8, 'ddos.exe', 2000, 0, 0, 0, 0, '15DFD41BA9A0776122EB31BBA9CC3168D67EE7E621AA344C7DF2B35DE73EE769', 'ZQ]PZ0<71', 0, 'sIT', 0, '2018-12-24 11:14:51', 'Not Def', '2018-12-24 11:14:51', '2018-12-24 11:14:51', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(9, 'PieselAlkocholik', 2000, 0, 0, 0, 0, '8FABAB59956FE68857193C7A951AE91E9DDBE3DDFE99539746F587B5C351DCCD', 'DV0TUNEMJ:', 0, 'sIT', 0, '2018-12-24 12:14:04', 'Not Def', '2018-12-24 12:14:04', '2018-12-24 12:14:04', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(10, 'elo', 2000, 0, 0, 0, 0, '457D8DC3ECDEFD95F97B8C21614685D25D5423C62A0E9C6EB3243E3304DC47E0', 'S[;0DHQWT8', 0, 'sIT', 0, '2018-12-24 13:12:33', 'Not Def', '2018-12-24 13:12:33', '2018-12-24 13:12:33', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(11, 'EasyZielak', 2000, 0, 0, 0, 0, '127D7325288D2811A233360C5E245AF611E88B2B0C02C74E369F8D0D80D03301', 'EL;M<O91YA', 0, 'sIT', 0, '2018-12-24 19:01:11', 'Not Def', '2018-12-24 19:01:11', '2018-12-24 19:01:11', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(12, 'Jamajka', 2000, 0, 0, 0, 0, '58F20512BCC5F4C92FA79D5DAC8AA1E91D4D817457272C3C08D15A96754B5BA4', 'E6?@P=6?DC', 0, 'sIT', 0, '2018-12-24 21:20:59', 'Not Def', '2018-12-24 21:20:59', '2018-12-24 21:20:59', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(13, 'ddos(exe)', 2000, 0, 0, 0, 0, '168AE5CF8AB28001DC853BDA960661C61E23FA28D3C5683E994FE485A98D9EAF', '86EAM3INE', 0, 'sIT', 0, '2018-12-24 21:22:51', 'Not Def', '2018-12-24 21:22:51', '2018-12-24 21:22:51', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(17, 'Zielak', 2000, 0, 0, 0, 0, '39156F64A26825D3605F162FEE6CDFC4FA7C4AC5FA581B012E060DE7C381CD53', 'M73B:ID7>', 0, 'sIT', 0, '2018-12-25 20:03:47', 'Not Def', '2018-12-25 20:03:47', '2018-12-25 20:03:47', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(14, 'KorwinPresidentek', 2000, 0, 0, 0, 0, '711F317DE3A94E6888D08062A7F1E6911A6ED01AEEB4A4125D6D4879CF4661A0', 'UE;7JT==OU', 0, 'sIT', 0, '2018-12-25 18:33:57', 'Not Def', '2018-12-25 18:33:57', '2018-12-25 18:33:57', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(16, 'Look_At_Me', 2000, 0, 0, 0, 0, '687D85B1DD644C202AE20D44FF553C038B787CD1872E99134C7DDDFF0F28A434', '28Q1N9<QZL', 0, 'sIT', 0, '2018-12-25 19:40:10', 'Not Def', '2018-12-25 19:40:10', '2018-12-25 19:40:10', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(15, 'DaxLer', 2000, 0, 0, 0, 0, '8C5601265844ADA3CD833A560A0CBA50362E0A2E82A1A689EC4C2530613D4418', '9VE?XYB@F7', 0, 'sIT', 0, '2018-12-25 19:37:57', 'Not Def', '2018-12-25 19:37:57', '2018-12-25 19:37:57', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(18, 'compelling', 2000, 0, 0, 0, 0, '063A2BD9705D10FE6AAD19FC7656F17239B2B0E84D6436142CA852DDCE82EEE5', '>X:EZ=A[QC', 0, 'sIT', 0, '2018-12-28 17:07:44', 'Not Def', '2018-12-28 17:07:44', '2018-12-28 17:07:44', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(19, 'Igl_', 2000, 51, 1, 0, 1, 'BF860F99C7DD24D84D3D3200179370F2873242514C419AC0CD5074781E3461E6', 'LSV>URFXXS', 0, 'sIT', 0, '2019-01-02 16:36:43', 'Not Def', '2019-01-02 16:36:43', '2019-01-02 16:36:43', 'CLEAR', 230, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, '83.28.247.54', '', 0, -1),
(20, 'sarenek', 2000, 0, 0, 0, 0, '9D03C53BF3A89EFE8C5A9E747449EDFC87549635DEA1A6F3B07750BB09D5843C', 'KE<2=19A_O', 0, 'sIT', 0, '2019-01-02 20:09:22', 'Not Def', '2019-01-02 20:09:22', '2019-01-02 20:09:22', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(21, 'don_mariuszo', 2000, 0, 0, 0, 0, '7BC7663F0AA8A51291037B6E75D9C51A7725E932E77A34B6B5AD10590A547C2E', 'Z0ER?:V6SM', 0, 'sIT', 0, '2019-01-06 12:40:37', 'Not Def', '2019-01-06 12:40:37', '2019-01-06 12:40:37', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(22, 'Merq.', 2000, -407, 0, 0, 0, '4280F4FE6089B1DABAAA342EDC3449257177BCAD7D8FA5B574EC45DA9B302063', '5K?]QFIER', 0, 'sIT', 0, '2019-01-07 17:12:22', 'Not Def', '2019-01-07 17:12:22', '2019-01-07 17:12:22', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 153, 0, '185.251.84.48', '98C0AFCF8A8E0EE5855ACC9E944DEA99D480DC88', 0, -1),
(23, 'huj', 2000, 0, 0, 0, 0, '038E0DDA9DF859D3378B6C22A2EB891121EDBD91717F46FEBD9DDBA19771D463', 'F3XZGOJTJP', 0, 'sIT', 0, '2019-01-14 21:00:57', 'Not Def', '2019-01-14 21:00:57', '2019-01-14 21:00:57', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1),
(24, 'Zbysiu', 2000, 0, 0, 0, 0, '26BAACAAA3C640A4545207A27BDBF1DEA26F0DF27045B788512A2C8184DE605A', 'UFS2UT0]K]', 0, 'sIT', 0, '2019-01-14 21:02:29', 'Not Def', '2019-01-14 21:02:29', '2019-01-14 21:02:29', 'CLEAR', 0, 0, 0, 0, -1, 0, 0, 0, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '255.255.255.255', '', 0, -1);

-- --------------------------------------------------------

--
-- Table structure for table `privc`
--

CREATE TABLE `privc` (
  `id` int(11) NOT NULL,
  `color1` int(11) NOT NULL DEFAULT '0',
  `color2` int(11) NOT NULL DEFAULT '0',
  `Paintjob` int(11) NOT NULL DEFAULT '0',
  `Components` varchar(75) NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0,0,0',
  `Neon` tinyint(4) NOT NULL DEFAULT '-1',
  `Oid` int(11) NOT NULL DEFAULT '-1',
  `LaX` float NOT NULL DEFAULT '0',
  `LaY` float NOT NULL DEFAULT '0',
  `LaZ` float NOT NULL DEFAULT '0',
  `LaAn` float NOT NULL DEFAULT '0',
  `pcmodel` int(11) NOT NULL DEFAULT '400',
  `cxp` int(11) NOT NULL DEFAULT '150',
  `cmo` int(11) NOT NULL DEFAULT '150',
  `przebieg` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `privc`
--

INSERT INTO `privc` (`id`, `color1`, `color2`, `Paintjob`, `Components`, `Neon`, `Oid`, `LaX`, `LaY`, `LaZ`, `LaAn`, `pcmodel`, `cxp`, `cmo`, `przebieg`) VALUES
(2, 195, 168, 0, '1058,0,1055,1056,0,0,1059,1083,0,1087,1155,1154,0,0', -1, 1, 2469.85, -1664.28, 13.1273, 73.9053, 561, 0, 0, 0),
(3, 234, 107, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0', 0, 3, 2135.52, -81.0429, 2.7598, 71.2378, 411, 0, 0, 0),
(4, 87, 249, 0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0', -1, 4, -3000, -3000, -3000, 300, 562, 4464000, 347200, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `GaS`
--
ALTER TABLE `GaS`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `GZones`
--
ALTER TABLE `GZones`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `HoS`
--
ALTER TABLE `HoS`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `plys`
--
ALTER TABLE `plys`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `privc`
--
ALTER TABLE `privc`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `RCa`
  ADD PRIMARY KEY (`id`);
--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `GaS`
--
ALTER TABLE `GaS`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `GZones`
--
ALTER TABLE `GZones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `HoS`
--
ALTER TABLE `HoS`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `plys`
--
ALTER TABLE `plys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `privc`
--
ALTER TABLE `privc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
