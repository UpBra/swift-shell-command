//
// Shell.swift
// Copyright © 2021 GLEESH. All rights reserved.
//

import Foundation


struct Shell {

	let url: URL
	let arguments: [String]

	init(url: URL, arguments: [String]) {
		self.url = url
		self.arguments = arguments
	}

	init(path: String, arguments: [String]) {
		self.url = URL(fileURLWithPath: path)
		self.arguments = arguments
	}

	struct Response {
		let output: String
	}

	enum Issue: Error {
		case noOutput
		case failed(Int32)
	}

	func run(_ completion: @escaping (Result<Response, Error>) -> Void) {
		let errorPipe = Pipe()
		var errorData = Data()
		let outputPipe = Pipe()
		var outputData = Data()

		let process = Process()
		process.executableURL = url
		process.arguments = arguments
		process.standardOutput = outputPipe
		process.standardError = errorPipe

		outputPipe.fileHandleForReading.readabilityHandler = { handle in
			outputData.append(handle.availableData)
		}

		errorPipe.fileHandleForReading.readabilityHandler = { handle in
			errorData.append(handle.availableData)
		}

		process.terminationHandler = { process in
			try? outputPipe.fileHandleForReading.close()
			try? errorPipe.fileHandleForReading.close()

			guard process.terminationStatus == 0 else {
				completion(.failure(Issue.failed(process.terminationStatus)))
				return
			}

			guard let result = String(data: outputData, encoding: .utf8), !result.isEmpty else {
				completion(.failure(Issue.noOutput))
				return
			}

			let response = Response(output: result)

			completion(.success(response))
		}

		do {
			try process.run()
		} catch {
			completion(.failure(error))
		}
	}
}
