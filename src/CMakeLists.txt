set(SRC
    main.cpp
)

qtquick_compiler_add_resources(RESOURCES qml/glacier-contacts.qrc)

add_executable(glacier-contacts ${SRC} ${RESOURCES})

target_link_libraries(glacier-contacts
	Qt5::Gui
	Qt5::Qml
	Qt5::Quick
	Glacier::App)

install(TARGETS glacier-contacts RUNTIME
	DESTINATION ${CMAKE_INSTALL_BINDIR})
install(DIRECTORY qml
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-contacts
    PATTERN "api" EXCLUDE)
install(DIRECTORY qml/api/
    DESTINATION
    ${INSTALL_QML_IMPORT_DIR}/org/nemomobile/qmlcontacts)
