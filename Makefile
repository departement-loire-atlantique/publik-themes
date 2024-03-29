NAME := la-publik-themes

prefix = /usr/share/publik/themes/publik-base
# prefix for devinst
#prefix = /usr/local/share/publik-devinst/themes/publik-base

all: css

data_uris:
	python3 make_data_uris.py --source static/loireatlantique/images/ --source publik-base-theme/static/includes/img/ --dest static/loireatlantique/_data_uris.scss --dest publik-base-theme/static/includes/_data_uris.scss

css: export LC_ALL=C.UTF-8
css: data_uris
	cd static/loireatlantique/ && sassc style.scss style.css
	rm -rf static/*/.sass-cache/

clean:
	rm -f publik-base-theme/static/includes/_data_uris.scss ; \
        rm -rf $(DESTDIR)$(prefix)/static/loireatlantique ; \
        rm -rf $(DESTDIR)$(prefix)/templates/variants/loireatlantique
        
install: css
	# Create a link for static files (js, css, images, ...) into the public base theme directory
	test -d $(DESTDIR)$(prefix)/static
	cp -R static/loireatlantique $(DESTDIR)$(prefix)/static/ 	

	# Create a link for custom templates into the public base theme directory
	test -d $(DESTDIR)$(prefix)/templates/variants
	mkdir -p $(DESTDIR)$(prefix)/templates/variants/loireatlantique
	cp -R templates/* $(DESTDIR)$(prefix)/templates/variants/loireatlantique/ 

	# Keep only publik and loireatlantique themes (delete link to other themes) 
	test -d $(DESTDIR)$(prefix)/themes.json ; \
        rm $(DESTDIR)$(prefix)/themes.json ; \
        cp themes.json $(DESTDIR)$(prefix)/themes.json	

install_interne: install
	cp -R static-interne/loireatlantique $(DESTDIR)$(prefix)/static/ 
	cp -R templates-interne/* $(DESTDIR)$(prefix)/templates/variants/loireatlantique/ 

version:
	@(echo $(VERSION))

name:
	@(echo $(NAME))

fullname:
	@(echo $(NAME)-$(VERSION))
