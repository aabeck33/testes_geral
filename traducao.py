import gettext

locale = input("Please enter the preferred locale (en, br):")

# Set the local directory
appname = 'traducao'
localedir = './locales'

# Set up Gettext
i18n = gettext.translation(appname, localedir, fallback=True, languages=[locale.strip()])

# Create the "magic" function
i18n.install()

# Translate message
print(_("Hello World"))