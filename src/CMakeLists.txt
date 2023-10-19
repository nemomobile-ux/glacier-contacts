set(SRC
    main.cpp
)

qt_add_resources(RESOURCES qml/glacier-contacts.qrc)

add_executable(glacier-contacts ${SRC} ${RESOURCES})

target_link_libraries(glacier-contacts
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
	Glacier::App)

install(TARGETS glacier-contacts RUNTIME
	DESTINATION ${CMAKE_INSTALL_BINDIR})

install(DIRECTORY qml/api/
    DESTINATION
    ${INSTALL_QML_IMPORT_DIR}/org/nemomobile/qmlcontacts)
