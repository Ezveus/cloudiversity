# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all

administrator = User.create({ first_name: "Bruce", last_name: "Almighty", login: "administrator", email: "bruce@paradise.com", password: "password", password_confirmation: "password" })

liliana = User.create({ first_name: "Liliana", last_name: "Vess", login: "liliana", email: "liliana@planeswalkers.com", password: "password", password_confirmation: "password" })
jace = User.create({ first_name: "Jace", last_name: "Beleren", login: "jace_login", email: "jace@planeswalkers.com", password: "password", password_confirmation: "password" })
ajani = User.create({ first_name: "Ajani", last_name: "Goldmane", login: "ajani_login", email: "ajani@planeswalkers.com", password: "password", password_confirmation: "password" })

garruk = User.create({ first_name: "Garruk", last_name: "Wildspeaker", login: "garruk_login", email: "garruk@planeswalkers.com", password: "password", password_confirmation: "password" })
chandra = User.create({ first_name: "Chandra", last_name: "Nalaar", login: "chandra_login", email: "chandra@planeswalkers.com", password: "password", password_confirmation: "password" })
gideon = User.create({ first_name: "Gidéon", last_name: "Jura", login: "gideon_login", email: "gideon@planeswalkers.com", password: "password", password_confirmation: "password" })

User.create(
            [
                { first_name: "Sorin", last_name: "Markov", login: "sorin_login", email: "sorin@planeswalkers.com", password: "password", password_confirmation: "password" },
                { first_name: "Nissa", last_name: "Revane", login: "nissa_login", email: "nissa@planeswalkers.com", password: "password", password_confirmation: "password" }
                ])

SchoolClass.destroy_all

ts1 = SchoolClass.create({ name: "TS1" })
tes1 = SchoolClass.create({ name: "TES1" })
tl = SchoolClass.create({ name: "TL" })

SchoolClass.create(
                   [
                    { name: "TS2" },
                    { name: "TS3" },
                    { name: "TS4" },
                    { name: "TS5" },
                    { name: "TS6" },
                    { name: "TES2" },
                    { name: "TES3" },
                    { name: "TES4" }
                    ])

Discipline.destroy_all

maths = Discipline.create({ name: "Mathématiques" })
philo = Discipline.create({ name: "Philosophie" })
ses = Discipline.create({ name: "Sciences Économiques et Sociales" })

Discipline.create(
                  [
                    { name: "Sciences de la Vie et de la Terre" },
                    { name: "Physique-Chimie" },
                    { name: "Littérature" },
                    { name: "Éducation Physique et Sportive" }
                    ])

Teacher.destroy_all
Teacher.create(
               [
                { user: liliana },
                { user: jace },
                { user: ajani }
                ])

Student.destroy_all
Student.create(
               [
                { user: garruk, school_class: ts1 },
                { user: chandra, school_class: tes1 },
                { user: gideon, school_class: tl }
                ])

TeacherSchoolClassDiscipline.destroy_all
TeacherSchoolClassDiscipline.create(
                                    [
                                        { teacher: liliana.as_teacher, school_class: ts1, discipline: maths },
                                        { teacher: jace.as_teacher, school_class: tl, discipline: philo },
                                        { teacher: ajani.as_teacher, school_class: tes1, discipline: ses }])
