cmake_minimum_required(VERSION 3.18)

project("vadim-kalinnikov-wallpapers")

install(DIRECTORY wallpapers DESTINATION share)
install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/gnome-background-properties" DESTINATION share)


file(GLOB items LIST_DIRECTORIES true "${CMAKE_CURRENT_SOURCE_DIR}/wallpapers/*")

foreach(item IN LISTS items)
	if(IS_DIRECTORY "${item}")
		cmake_path(GET item FILENAME image_id)
		execute_process(
			COMMAND jq -r .KPlugin.Name wallpapers/${image_id}/metadata.json
			WORKING_DIRECTORY  ${CMAKE_SOURCE_DIR}
			OUTPUT_VARIABLE image_name
			OUTPUT_STRIP_TRAILING_WHITESPACE
		)
		file(GLOB image_files "${CMAKE_CURRENT_SOURCE_DIR}/wallpapers/${image_id}/contents/images/*")
		list(LENGTH image_files images_count)
		if (images_count EQUAL 0)
			message(STATUS "No images found for ${image_id}")
			continue()
		endif()
		list(GET image_files 0 image_path_first)
		file(RELATIVE_PATH image_path "${CMAKE_CURRENT_SOURCE_DIR}" "${image_path_first}")
		set(full_image_path ${CMAKE_INSTALL_PREFIX}/share/${image_path})

		configure_file(
			"${CMAKE_CURRENT_SOURCE_DIR}/template.xml"
			"${CMAKE_CURRENT_BINARY_DIR}/gnome-background-properties/${image_id}.xml"
			@ONLY
		)
		
		message(STATUS "Image title: ${image_name}\nImage path: ${full_image_path}")
	endif()
endforeach()
