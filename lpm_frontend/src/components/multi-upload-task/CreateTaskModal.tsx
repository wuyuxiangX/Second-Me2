'use client';

import { useState } from 'react';

interface UploadParticipant {
  name: string;
  apiEndpoint: string;
  apiKey: string;
}

interface CreateTaskModalProps {
  onClose: () => void;
  onSubmit: (taskData: { description: string; participants: UploadParticipant[] }) => void;
  currentUploadName: string;
}

export default function CreateTaskModal({
  onClose,
  onSubmit,
  currentUploadName
}: CreateTaskModalProps) {
  const [description, setDescription] = useState('');
  const [participants, setParticipants] = useState<UploadParticipant[]>([
    { name: currentUploadName, apiEndpoint: '', apiKey: '' } // Current upload is default
  ]);

  const handleAddParticipant = () => {
    setParticipants([...participants, { name: '', apiEndpoint: '', apiKey: '' }]);
  };

  const handleParticipantChange = (
    index: number,
    field: keyof UploadParticipant,
    value: string
  ) => {
    const newParticipants = [...participants];

    newParticipants[index] = { ...newParticipants[index], [field]: value };
    setParticipants(newParticipants);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit({ description, participants });
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg p-6 max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <h2 className="text-2xl font-bold mb-4">Create New Multi-Upload Task</h2>

        <form className="space-y-6" onSubmit={handleSubmit}>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Task Description</label>
            <textarea
              className="w-full rounded-md border border-gray-300 p-3 min-h-[100px]"
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Describe the task that the uploads should complete..."
              required
              value={description}
            />
          </div>

          <div>
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-medium">Participating Uploads</h3>
              <button
                className="text-blue-600 hover:text-blue-700"
                onClick={handleAddParticipant}
                type="button"
              >
                + Add Upload
              </button>
            </div>

            <div className="space-y-4">
              {participants.map((participant, index) => (
                <div key={index} className="border rounded-lg p-4">
                  <div className="grid gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        Upload Name
                      </label>
                      <input
                        className="w-full rounded-md border border-gray-300 p-2"
                        disabled={index === 0} // Current upload can't be changed
                        onChange={(e) => handleParticipantChange(index, 'name', e.target.value)}
                        required
                        type="text"
                        value={participant.name}
                      />
                    </div>
                    {index !== 0 && ( // Only show API fields for other uploads
                      <>
                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-1">
                            API Endpoint
                          </label>
                          <input
                            className="w-full rounded-md border border-gray-300 p-2"
                            onChange={(e) =>
                              handleParticipantChange(index, 'apiEndpoint', e.target.value)
                            }
                            required
                            type="url"
                            value={participant.apiEndpoint}
                          />
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-1">
                            API Key
                          </label>
                          <input
                            className="w-full rounded-md border border-gray-300 p-2"
                            onChange={(e) =>
                              handleParticipantChange(index, 'apiKey', e.target.value)
                            }
                            required
                            type="password"
                            value={participant.apiKey}
                          />
                        </div>
                      </>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="flex justify-end gap-4">
            <button
              className="px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50"
              onClick={onClose}
              type="button"
            >
              Cancel
            </button>
            <button
              className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
              type="submit"
            >
              Create Task
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
