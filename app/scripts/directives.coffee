angular.module('app')
	.directive 'slingDrop', ($http) ->
		return {
			restrict: 'AE'
			templateUrl: 'templates/dropbox.html'
			scope: 
				uploadUrl: '@'
				onUploadComplete: '&'
			link: (scope, element, attrs) ->
				console.log 'sling drop recognized'
				$el = $(element)
				console.log 'link scope', scope
				scope.progress =
					show: false

				processDragOverOrEnter = (event) ->
					event?.preventDefault()
					console.log 'processDragOverOrEnter'
					$el.addClass('active')

				$el.on 'dragover', processDragOverOrEnter
				$el.on 'dragenter', processDragOverOrEnter

				$el.on 'drop', (event) ->
					event?.preventDefault()
					scope.$apply ->
						scope.progress.show = true
						oevent = event.originalEvent
						console.log('drop evt:', oevent.dataTransfer)
						reader = new FileReader()
						files = oevent.dataTransfer.files
						console.log 'drop scope',scope
						uploadFiles(files)

				uploadFiles = (files) =>
					console.log 'upload scope:', scope.progress
					console.log 'progrss:', scope.progress
					fd = new FormData()
					_.each files, (file) -> 
						fd.append 'uploadedFiles', file

					xhr = new XMLHttpRequest()
					xhr.upload.addEventListener 'progress', updateProgress
					xhr.addEventListener 'load', uploadComplete
					xhr.addEventListener 'error', uploadFailed
					xhr.addEventListener 'abort', uploadCanceled
					xhr.open 'POST',scope.uploadUrl
					xhr.send(fd)


				updateProgress = (evt) ->
					scope.$apply ->
						if evt.lengthComputable
							scope.progress.percent = Math.round( evt.loaded * 100 / evt.total)
							scope.progress.message = scope.progress.percent + '%'
						else
							scope.progress.percent = 100
							scope.progress.message = 'Uploading...'

				uploadComplete = (evt) ->
					console.log 'upload complete'
					scope.progress.show = false
					scope.onUploadComplete()

				uploadFailed = (evt) ->
					console.log 'upload failed'

				uploadCanceled = (evt) ->
					console.log 'upload uploadCanceled'
		}

