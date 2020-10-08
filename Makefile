NAME := la-publik-themes

prefix = /usr

all: css

data_uris:
	python make_data_uris.py --source static/loireatlantique/images/ --source publik-base-theme/static/includes/img/ --dest static/loireatlantique/_data_uris.scss --dest publik-base-theme/static/includes/_data_uris.scss

css: export LC_ALL=C.UTF-8
css: data_uris
	cd static/loireatlantique/ && sassc style.scss style.css
	rm -rf static/*/.sass-cache/

clean:
	rm -f publik-base-theme/static/includes/_data_uris.scss ; \
        rm -rf $(DESTDIR)$(prefix)/share/publik/themes/publik-base/static/loireatlantique ; \
        rm -rf $(DESTDIR)$(prefix)/share/publik/themes/publik-base/templates/variants/loireatlantique
        
install: css
	# Create a link for static files (js, css, images, ...) into the public base theme directory
	test -d $(DESTDIR)$(prefix)/share/publik/themes/publik-base/static
	cp -R static/loireatlantique $(DESTDIR)$(prefix)/share/publik/themes/publik-base/static/ 	

	# Create a link for custom templates into the public base theme directory
	test -d $(DESTDIR)$(prefix)/share/publik/themes/publik-base/templates/variants
	mkdir -p $(DESTDIR)$(prefix)/share/publik/themes/publik-base/templates/variants/loireatlantique
	cp -R templates/* $(DESTDIR)$(prefix)/share/publik/themes/publik-base/templates/variants/loireatlantique/ 

	# Keep only publik and loireatlantique themes (delete link to other themes) 
	test -d $(DESTDIR)$(prefix)/share/publik/themes/publik-base/themes.json ; \
        rm $(DESTDIR)$(prefix)/share/publik/themes/publik-base/themes.json ; \
        cp themes.json $(DESTDIR)$(prefix)/share/publik/themes/publik-base/themes.json	

version:
	@(echo $(VERSION))

name:
	@(echo $(NAME))

fullname:
	@(echo $(NAME)-$(VERSION))
