## The type of library we want to build. Possible values:
##   relocatable
##   static
AWA_LIBRARY_TYPE=static
HAVE_PANDOC=yes
HAVE_DYNAMO=yes

-include Makefile.conf

STATIC_MAKE_ARGS = $(MAKE_ARGS) -XAWA_LIBRARY_TYPE=static
SHARED_MAKE_ARGS = $(MAKE_ARGS) -XAWA_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XELADA_BUILD=relocatable -XEL_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XSECURITYADA_BUILD=relocatable -XSECURITY_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XWIKIADA_BUILD=relocatable -XWIKI_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XASF_BUILD=relocatable -XASF_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XSERVLETADA_BUILD=relocatable -XSERVLET_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XADO_BUILD=relocatable -XADO_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XUTILADA_BASE_BUILD=relocatable -XUTIL_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XXMLADA_BUILD=relocatable
SHARED_MAKE_ARGS += -XXMLADA_BUILD=relocatable -XAWS_BUILD=relocatable
SHARED_MAKE_ARGS += -XUTILADA_HTTP_AWS_BUILD=relocatable
SHARED_MAKE_ARGS += -XUTILADA_HTTP_AWS_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XUTILADA_UNIT_BUILD=relocatable
SHARED_MAKE_ARGS += -XUTIL_UNIT_LIBRARY_TYPE=relocatable
SHARED_MAKE_ARGS += -XLIBRARY_TYPE=relocatable

include Makefile.defaults

PLUGINS=awa-workspaces awa-mail awa-counters awa-storages awa-images awa-comments \
        awa-jobs awa-votes awa-tags awa-flotcharts awa-wikis awa-blogs awa-markedit \
        awa-trumbowyg awa-questions \
	awa-countries awa-settings awa-changelogs awa-setup

NAME=awa
LIBNAME=lib${NAME}

# include rules.mk

DYNAMO_ARGS=--package AWA.Users.Models \
  --package AWA.Events.Models \
  --package AWA.OAuth.Models \
  --package AWA.Permissions.Models \
  --package AWA.Audits.Models \
  db uml/awa.zargo

build-test:: setup
	$(GNATMAKE) $(GPRFLAGS) -m -p -Pawa_tests $(MAKE_ARGS)

ifeq (${HAVE_PANDOC},yes)
ifeq (${HAVE_DYNAMO},yes)

AWA_DOC= \
  title.md \
  pagebreak.tex \
  index.md \
  pagebreak.tex \
  Installation.md \
  pagebreak.tex \
  Tutorial.md \
  pagebreak.tex \
  AWA.md \
  pagebreak.tex \
  AWA_Users.md \
  pagebreak.tex \
  AWA_Jobs.md \
  pagebreak.tex \
  AWA_Mail.md \
  pagebreak.tex \
  AWA_Storages.md \
  pagebreak.tex \
  AWA_Images.md \
  pagebreak.tex \
  AWA_Wikis.md \
  pagebreak.tex \
  AWA_Blogs.md \
  pagebreak.tex \
  AWA_Counters.md \
  pagebreak.tex \
  AWA_Votes.md \
  pagebreak.tex \
  AWA_Tags.md \
  pagebreak.tex \
  AWA_Comments.md \
  pagebreak.tex \
  AWA_Settings.md \
  pagebreak.tex \
  AWA_Setup.md \
  pagebreak.tex

DOC_OPTIONS=-f markdown -o awa-book.pdf --listings --number-sections --toc --filter ./filter.py
HTML_OPTIONS=-f markdown -o awa-book.html --listings --number-sections --toc --css pandoc.css

docs/awa-book.pdf:  force
	$(DYNAMO) build-doc -pandoc docs
	cd docs && pandoc $(DOC_OPTIONS) --template=./eisvogel.tex $(AWA_DOC)

docs/awa-book.html: docs/awa-book.pdf force
	cd docs && pandoc $(HTML_OPTIONS) $(AWA_DOC)
endif
endif

# Build and run the unit tests
check test:	test-mysql test-sqlite test-postgresql

regtests/result/maildir:
	mkdir -p $@

test-sqlite:		build regtests.db regtests/result/maildir
ifeq (${HAVE_SQLITE},True)
	bin/awa_harness -p SQLite -xml awa-sqlite-aunit.xml -config test-sqlite.properties
endif

test-mysql:		build create-mysql-tests regtests/result/maildir
ifeq (${HAVE_MYSQL},True)
	bin/awa_harness -p MySQL -xml awa-mysql-aunit.xml -config test-mysql.properties
endif

test-postgresql:		build create-postgresql-tests regtests/result/maildir
ifeq (${HAVE_POSTGRESQL},True)
	bin/awa_harness -p Postgresql -xml awa-postgresql-aunit.xml -config test-postgresql.properties
endif

# Create the test sqlite database
regtests.db:
	-rm -f $@
ifeq (${HAVE_SQLITE},True)
	sqlite3 $@ < db/sqlite/create-awa-sqlite.sql
endif

# Create the tables in the database.
# (The database itself must have been created)
create-mysql-tests:
ifeq (${HAVE_MYSQL},True)
	mysql --defaults-extra-file=db/mysql/mysql.cnf < db/mysql/drop-awa-mysql.sql
	mysql --defaults-extra-file=db/mysql/mysql.cnf < db/mysql/create-awa-mysql.sql
endif

# Create the tables in the database.
# (The database itself must have been created)
create-postgresql-tests:
ifeq (${HAVE_POSTGRESQL},True)
	psql -q "postgresql://localhost:5432/awa_test?user=awa_user&password=awa_pass" \
           --file=db/postgresql/drop-awa-postgresql.sql
	psql -q "postgresql://localhost:5432/awa_test?user=awa_user&password=awa_pass" \
           --file=db/postgresql/create-awa-postgresql.sql
endif

install::
	$(MKDIR) -p $(DESTDIR)${dynamodir}/base/uml
	$(MKDIR) -p $(DESTDIR)${prefix}/share/doc/awa
	# Install the AWA UML model in Dynamo UML search path
	unzip -cq uml/awa.zargo awa.xmi > $(DESTDIR)${dynamodir}/base/uml/AWA.xmi

uninstall::
	rm -rf $(DESTDIR)${dynamodir}/awa

$(eval $(call ada_library,awa))
$(eval $(call ada_library,awa_unit))
$(eval $(call awa_install_dir,awa,config,./))
$(eval $(call awa_install_dir,awa,db,./))
$(eval $(call awa_install_dir,awa,bundles,./))
$(eval $(call awa_install_dir,awa,web,./))
$(eval $(call awa_install_file,awa,dynamo.xml,./))
$(eval $(call awa_install_file,awa,NOTICE.txt,./))
$(eval $(call awa_install_file,awa,LICENSE.txt,./))

$(DESTDIR)$(dynamodir)/awa:
	$(MKDIR) -p $(DESTDIR)$(dynamodir)/awa

ROOTDIR=.

$(foreach PLUGIN,$(PLUGINS),$(eval include plugins/$(PLUGIN)/Makefile))
