-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le :  lun. 18 juin 2018 à 22:59
-- Version du serveur :  5.7.17
-- Version de PHP :  5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `pocnotesdefrais`
--

-- --------------------------------------------------------

--
-- Structure de la table `notesdefrais`
--

CREATE TABLE `notesdefrais` (
  `code` int(11) NOT NULL,
  `date` date NOT NULL DEFAULT '0000-00-00',
  `lieu` varchar(255) NOT NULL DEFAULT '',
  `montant` decimal(10,0) NOT NULL DEFAULT '0',
  `acceptee` char(1) NOT NULL DEFAULT 'N',
  `utilisateur_code` int(11) NOT NULL DEFAULT '0',
  `mobile_code` varchar(255) NOT NULL DEFAULT '',
  `dateaccord` date NOT NULL DEFAULT '0000-00-00',
  `avalider` char(1) NOT NULL DEFAULT 'O'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `code` int(10) UNSIGNED NOT NULL,
  `nom` varchar(255) NOT NULL DEFAULT '',
  `prenom` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `motdepasse` varchar(255) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `notesdefrais`
--
ALTER TABLE `notesdefrais`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `avalider` (`avalider`,`code`),
  ADD UNIQUE KEY `utilisateur_code` (`utilisateur_code`,`date`,`code`);

--
-- Index pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `email` (`email`(50),`motdepasse`(50),`code`),
  ADD UNIQUE KEY `nom` (`nom`(50),`prenom`(50),`code`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `notesdefrais`
--
ALTER TABLE `notesdefrais`
  MODIFY `code` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  MODIFY `code` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
