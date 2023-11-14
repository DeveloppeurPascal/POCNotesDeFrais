CREATE TABLE "notesdefrais" ( `code` INTEGER PRIMARY KEY AUTOINCREMENT, `utilisateur_code` INTEGER DEFAULT 0, `mobile_code` TEXT DEFAULT '', `datendf` TEXT DEFAULT '0000-00-00', `lieu` TEXT DEFAULT '', `montant` REAL DEFAULT 0, `avalider` TEXT DEFAULT 'O', `acceptee` TEXT DEFAULT 'N', `dateaccord` TEXT DEFAULT '0000-00-00' )
CREATE INDEX `par_avalider` ON `notesdefrais` ( `avalider`, `code` )
CREATE INDEX `par_utilisateur` ON `notesdefrais` ( `utilisateur_code`, `datendf`, `code` )
